@preconcurrency import AVFoundation
import Foundation

struct VoiceCaptureSnapshot: Codable, Sendable {
    var tapCallbacks = 0
    var audibleTapCallbacks = 0
    var lastInputPeak: Float = 0
    var maximumInputPeak: Float = 0
    var inputPeakSinceLastReport: Float = 0
    var lastTapAt: TimeInterval = 0
    var convertedChunks = 0
    var convertedBytes = 0
    var nonSilentConvertedChunks = 0
    var lastConversionAt: TimeInterval = 0
}

/// Only aggregate health metadata crosses from the real-time tap to the UI actor.
private final class VoiceCaptureHealth: @unchecked Sendable {
    private let lock = NSLock()
    private var value = VoiceCaptureSnapshot()
    var snapshot: VoiceCaptureSnapshot {
        lock.withLock {
            let snapshot = value
            value.inputPeakSinceLastReport = 0
            return snapshot
        }
    }
    func reset() { lock.withLock { value = VoiceCaptureSnapshot() } }

    func tapped(_ buffer: AVAudioPCMBuffer) {
        var peak: Float = 0
        if let channel = buffer.floatChannelData?[0] {
            for index in 0..<Int(buffer.frameLength) { peak = max(peak, abs(channel[index])) }
        } else if let channel = buffer.int16ChannelData?[0] {
            for index in 0..<Int(buffer.frameLength) { peak = max(peak, abs(Float(channel[index])) / 32_768) }
        }
        let now = Date().timeIntervalSince1970
        lock.withLock {
            value.tapCallbacks += 1
            if peak >= 0.01 { value.audibleTapCallbacks += 1 }
            value.lastInputPeak = peak
            value.maximumInputPeak = max(value.maximumInputPeak, peak)
            value.inputPeakSinceLastReport = max(value.inputPeakSinceLastReport, peak)
            value.lastTapAt = now
        }
    }

    func converted(_ data: Data) {
        let nonSilent = data.contains { $0 != 0 }
        let now = Date().timeIntervalSince1970
        lock.withLock {
            value.convertedChunks += 1
            value.convertedBytes += data.count
            if nonSilent { value.nonSilentConvertedChunks += 1 }
            value.lastConversionAt = now
        }
    }
}

enum VoiceAudioError: LocalizedError {
    case microphoneDenied, unavailable, conversion
    case playbackUnavailable(engineRunning: Bool, hasPlayer: Bool, byteCount: Int)

    var errorDescription: String? {
        switch self {
        case .microphoneDenied: "Microphone access is off. Enable it in Settings → Roasted to talk to Nobody."
        case .unavailable: "The microphone or speaker is unavailable. Reconnect your audio device and try again."
        case .conversion: "Microphone audio could not be prepared. Please start a new call."
        case let .playbackUnavailable(running, player, bytes):
            "Audio playback unavailable (engine running: \(running), player ready: \(player), PCM bytes: \(bytes))."
        }
    }
}

/// The converter is used only by the audio tap; the lock protects its mute flag.
private final class MicrophonePCM: @unchecked Sendable {
    private let converter: AVAudioConverter
    private let outputFormat: AVAudioFormat
    private let lock = NSLock()
    private var muted = false
    private var inputSupplied = false

    init(inputFormat: AVAudioFormat) throws {
        guard let format = AVAudioFormat(commonFormat: .pcmFormatInt16,
                                        sampleRate: 24_000, channels: 1, interleaved: true),
              let converter = AVAudioConverter(from: inputFormat, to: format) else {
            throw VoiceAudioError.conversion
        }
        self.outputFormat = format
        self.converter = converter
    }

    func setMuted(_ value: Bool) {
        lock.withLock { muted = value }
    }

    func convert(_ input: AVAudioPCMBuffer) throws -> Data? {
        let frameCount = AVAudioFrameCount(ceil(Double(input.frameLength) * 24_000 / input.format.sampleRate)) + 64
        guard let output = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: frameCount) else {
            throw VoiceAudioError.conversion
        }
        lock.withLock { inputSupplied = false }
        var error: NSError?
        let status = converter.convert(to: output, error: &error) { _, inputStatus in
            let shouldSupply = self.lock.withLock {
                guard !self.inputSupplied else { return false }
                self.inputSupplied = true
                return true
            }
            if !shouldSupply {
                inputStatus.pointee = .noDataNow
                return nil
            }
            inputStatus.pointee = .haveData
            return input
        }
        guard status != .error, error == nil else { throw VoiceAudioError.conversion }
        guard output.frameLength > 0, let samples = output.int16ChannelData?[0] else { return nil }
        let byteCount = Int(output.frameLength) * MemoryLayout<Int16>.size
        // Keep silence flowing while muted so server VAD can finish the previous turn.
        if lock.withLock({ muted }) { return Data(count: byteCount) }
        return Data(bytes: samples, count: byteCount)
    }
}

@MainActor
final class VoiceAudio {
    var onPlaybackFinished: (() -> Void)?
    var onPlaybackDiscarded: (() -> Void)?
    var isPlaying: Bool { scheduledBuffers > 0 }
    var captureDiagnostics: VoiceCaptureSnapshot { captureHealth.snapshot }
    var diagnostics: (running: Bool, voiceProcessing: Bool, inputRate: Double, outputs: [String]) {
        (engine?.isRunning == true, engine?.inputNode.isVoiceProcessingEnabled == true,
         engine?.inputNode.outputFormat(forBus: 0).sampleRate ?? 0,
         AVAudioSession.sharedInstance().currentRoute.outputs.map { $0.portType.rawValue })
    }
    private var engine: AVAudioEngine?
    private var player: AVAudioPlayerNode?
    private var microphone: MicrophonePCM?
    private var tapInstalled = false
    private var configurationObserver: (any NSObjectProtocol)?
    private var captureGeneration = UUID()
    private var onPCM: (@Sendable (Data) -> Void)?
    private var onCaptureFailure: (@Sendable () -> Void)?
    private var muted = false
    private let captureHealth = VoiceCaptureHealth()
    private var scheduledBuffers = 0
    private var playbackGeneration = UUID()
    private let playbackFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                               sampleRate: 24_000, channels: 1, interleaved: false)!

    static func requestPermission() async throws {
        let granted = await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { @Sendable allowed in
                continuation.resume(returning: allowed)
            }
        }
        if !granted { throw VoiceAudioError.microphoneDenied }
    }

    func start(onPCM: @escaping @Sendable (Data) -> Void,
               onFailure: @escaping @Sendable () -> Void) throws {
        stop()
        captureHealth.reset()
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetoothHFP])
        try session.setPreferredSampleRate(48_000)
        try session.setPreferredIOBufferDuration(0.02)
        try session.setActive(true)

        let engine = AVAudioEngine()
        self.engine = engine
        self.onPCM = onPCM
        self.onCaptureFailure = onFailure
        do {
            try engine.inputNode.setVoiceProcessingEnabled(true)
            let player = AVAudioPlayerNode()
            self.player = player
            engine.attach(player)
            engine.connect(player, to: engine.mainMixerNode, format: playbackFormat)
            try installMicrophoneTap(on: engine)
            let generation = captureGeneration
            configurationObserver = NotificationCenter.default.addObserver(
                forName: .AVAudioEngineConfigurationChange, object: engine, queue: nil
            ) { @Sendable [weak self] _ in
                Task { @MainActor in
                    guard let self, self.captureGeneration == generation else { return }
                    do { try self.restartStoppedEngine() }
                    catch { self.onCaptureFailure?() }
                }
            }
            engine.prepare()
            try engine.start()
            player.play()
        } catch {
            stop()
            throw error
        }
    }

    func setMuted(_ muted: Bool) {
        self.muted = muted
        microphone?.setMuted(muted)
    }

    func play(_ data: Data) throws {
        // A route-format change can stop the engine between activation and the
        // first packet (observed in Simulator). Rebuild capture at the new rate.
        try restartStoppedEngine()
        guard data.count.isMultiple(of: 2), !data.isEmpty,
              let player, engine?.isRunning == true,
              let buffer = AVAudioPCMBuffer(pcmFormat: playbackFormat,
                                            frameCapacity: AVAudioFrameCount(data.count / 2)),
              let channel = buffer.floatChannelData?[0] else {
            throw VoiceAudioError.playbackUnavailable(engineRunning: engine?.isRunning == true,
                                                       hasPlayer: self.player != nil, byteCount: data.count)
        }
        buffer.frameLength = buffer.frameCapacity
        // Read bytes explicitly: Data's base address need not be Int16-aligned.
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            for frame in 0..<Int(buffer.frameLength) {
                let bits = UInt16(bytes[frame * 2]) | (UInt16(bytes[frame * 2 + 1]) << 8)
                channel[frame] = Float(Int16(bitPattern: bits)) / 32_768
            }
        }
        let generation = playbackGeneration
        scheduledBuffers += 1
        player.scheduleBuffer(buffer, completionCallbackType: .dataPlayedBack) { @Sendable [weak self] _ in
            Task { @MainActor in
                guard let self, self.playbackGeneration == generation else { return }
                self.scheduledBuffers = max(0, self.scheduledBuffers - 1)
                if self.scheduledBuffers == 0 { self.onPlaybackFinished?() }
            }
        }
        if !player.isPlaying { player.play() }
    }

    func interruptPlayback() {
        playbackGeneration = UUID()
        scheduledBuffers = 0
        player?.stop()
        if engine?.isRunning == true { player?.play() }
    }

    func stop() {
        captureGeneration = UUID()
        if let configurationObserver { NotificationCenter.default.removeObserver(configurationObserver) }
        configurationObserver = nil
        playbackGeneration = UUID()
        scheduledBuffers = 0
        if tapInstalled { engine?.inputNode.removeTap(onBus: 0) }
        tapInstalled = false
        player?.stop()
        engine?.stop()
        player = nil
        engine = nil
        microphone = nil
        onPCM = nil
        onCaptureFailure = nil
        muted = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func installMicrophoneTap(on engine: AVAudioEngine) throws {
        guard let onPCM, let onCaptureFailure else { throw VoiceAudioError.unavailable }
        if tapInstalled { engine.inputNode.removeTap(onBus: 0) }
        tapInstalled = false
        let format = engine.inputNode.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0 else { throw VoiceAudioError.unavailable }
        let microphone = try MicrophonePCM(inputFormat: format)
        microphone.setMuted(muted)
        self.microphone = microphone
        let captureHealth = captureHealth
        engine.inputNode.installTap(onBus: 0, bufferSize: 1_024, format: format) { @Sendable buffer, _ in
            captureHealth.tapped(buffer)
            do {
                if let data = try microphone.convert(buffer) {
                    captureHealth.converted(data)
                    onPCM(data)
                }
            } catch {
                onCaptureFailure()
            }
        }
        tapInstalled = true
    }

    private func restartStoppedEngine() throws {
        guard let engine, !engine.isRunning else { return }
        if scheduledBuffers > 0 { onPlaybackDiscarded?() }
        playbackGeneration = UUID()
        scheduledBuffers = 0
        player?.stop()
        engine.stop()
        try installMicrophoneTap(on: engine)
        engine.prepare()
        try engine.start()
        player?.play()
    }
}
