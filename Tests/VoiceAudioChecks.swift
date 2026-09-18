import Foundation
import Testing
@testable import Roasted

/// Aggregate counts only: this test never retains microphone samples or uses a provider.
private final class AudioCaptureCounts: @unchecked Sendable {
    private let lock = NSLock()
    private var chunks = 0
    private var nonSilentChunks = 0
    private var failures = 0

    func received(_ data: Data) {
        let hasSound = data.contains { $0 != 0 }
        lock.withLock {
            chunks += 1
            if hasSound { nonSilentChunks += 1 }
        }
    }

    func failed() { lock.withLock { failures += 1 } }
    func reset() { lock.withLock { chunks = 0; nonSilentChunks = 0; failures = 0 } }
    var snapshot: (chunks: Int, nonSilentChunks: Int, failures: Int) {
        lock.withLock { (chunks, nonSilentChunks, failures) }
    }
}

struct VoiceAudioChecks {
    @MainActor @Test func mutedRuntimeCaptureAndPlayback() async throws {
        try await VoiceAudio.requestPermission()
        let audio = VoiceAudio()
        defer { audio.stop() }
        let counts = AudioCaptureCounts()
        var completed = false
        audio.onPlaybackFinished = { completed = true }

        // Exercise a second start as well: stale callbacks/taps must not survive stop().
        for run in 1...2 {
            completed = false
            try audio.start(onPCM: { counts.received($0) }, onFailure: { counts.failed() })
            audio.setMuted(true)
            try await Task.sleep(for: .milliseconds(500))
            counts.reset()

            // A quiet 150ms sine tone is synthetic PCM, not speech or recorded audio.
            var tone = Data()
            for sample in 0..<3_600 {
                let amplitude = sin(Double(sample) * 2 * .pi * 440 / 24_000) * 1_000
                let bits = UInt16(bitPattern: Int16(amplitude))
                tone.append(UInt8(bits & 0xff))
                tone.append(UInt8(bits >> 8))
            }
            try audio.play(tone)
            #expect(audio.isPlaying)
            for _ in 0..<30 {
                if completed { break }
                try await Task.sleep(for: .milliseconds(100))
            }
            try await Task.sleep(for: .milliseconds(300))
            let capture = counts.snapshot
            let route = audio.diagnostics
            print("VoiceAudio runtime run=\(run) running=\(route.running) voiceProcessing=\(route.voiceProcessing) inputRate=\(route.inputRate) outputTypes=\(route.outputs) mutedChunks=\(capture.chunks) nonSilentChunks=\(capture.nonSilentChunks) playbackCompleted=\(completed)")
            #expect(route.running)
            #expect(route.voiceProcessing)
            #expect(route.inputRate > 0)
            #expect(capture.chunks > 0)
            #expect(capture.nonSilentChunks == 0)
            #expect(capture.failures == 0)
            #expect(completed)
            #expect(!audio.isPlaying)
            audio.stop()
            #expect(!audio.diagnostics.running)
        }
    }
}
