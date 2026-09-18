import Foundation
import Observation

struct ConversationLine: Identifiable, Codable, Equatable {
    let id: String
    let speaker: String
    let text: String
}

struct LearningSignal: Identifiable, Codable, Equatable {
    var id: String { originalQuote }
    let kind: String
    let signal: String
    let originalQuote: String
    let nativeAlternative: String
    let retryQuote: String
    let improvementObserved: Bool
}

struct LearningReceipt: Identifiable, Codable, Equatable {
    let id: String
    let createdAt: String
    let topic: String
    let signals: [LearningSignal]
    let usefulExpression: String
    let culturalTakeaway: String
    let isMock: Bool
}

@MainActor @Observable
final class CallSession {
    enum Phase { case home, incoming, connecting, active, saving, receipt, failed }
    var phase: Phase = .home
    private(set) var isMock = true
    var isMuted = false
    var status = "Ready when you are"
    var errorMessage: String?
    var messages: [ConversationLine] = []
    var receipt: LearningReceipt?
    var savedReceipts: [LearningReceipt] = []
    var memorySummary = "No live learner memory loaded"
    let topicTitle = "Does every phone upgrade need to be a personality?"
    let topicContext = "Apple announced iPhone 18 Pro on September 9, with availability from September 18. It highlights camera, battery and performance upgrades. Does that make upgrading worth it—or is the hype doing the work?"
    let topicDate = "September 18, 2026"
    let topicSourceURL = URL(string: "https://www.apple.com/newsroom/2026/09/apple-debuts-iphone-18-pro-and-iphone-18-pro-max/")!
    private var mockStep = 0
    var canRetrySave = false
    @ObservationIgnored private var backend: DemoBackend?
    @ObservationIgnored private var voice: HiggsVoiceClient?
    @ObservationIgnored private var liveTask: Task<Void, Never>?
    @ObservationIgnored private var generation: UUID?
    @ObservationIgnored private var callID = ""
    @ObservationIgnored private var callCreatedAt = ""
    @ObservationIgnored private var candidates: [[String: Any]] = []
    @ObservationIgnored private var itemOrder: [String] = []
    @ObservationIgnored private var interruptedAssistantIDs = Set<String>()

    init(configuration: DemoConfiguration? = DemoConfiguration.load()) {
        if let configuration {
            backend = DemoBackend(configuration: configuration)
            isMock = false
            status = "Higgs ready"
        }
    }

    var liveAvailable: Bool { backend != nil }

    func toggleDemoMode() {
        guard phase == .home, backend != nil else { return }
        isMock.toggle()
        memorySummary = isMock ? "Mock learning is never saved" : "Retrieving learner memory…"
        if !isMock { Task { await refreshMemory() } }
    }

    func refreshMemory() async {
        guard !isMock, let backend else { return }
        do {
            let result = try await backend.memory()
            guard !isMock else { return }
            savedReceipts = result.receipts
            showMemory(result.memory)
        } catch {
            memorySummary = "Learner memory unavailable. Check the Mac backend before calling."
        }
    }

    func ring() {
        guard phase == .home else { return }
        phase = .incoming
    }

    func decline() {
        guard phase == .incoming else { return }
        phase = .home
    }

    func accept() {
        guard phase == .incoming else { return }
        messages = []
        receipt = nil
        errorMessage = nil
        mockStep = 0
        isMuted = false
        canRetrySave = false
        if !isMock {
            startLive()
            return
        }
        phase = .active
        status = "Sample conversation"
        append("Nobody", "Apple announces a new phone and suddenly everyone's old one is a family embarrassment. Are you buying the upgrade, or just judging the people who do?")
    }

    func advanceMock() {
        guard isMock, phase == .active else { return }
        mockStep += 1
        switch mockStep {
        case 1:
            append("You", "People is overreacting because Apple don't really change much.")
            append("Nobody", "Apple sells you the same rectangle; you sell me ‘people is.’ Neither of you respects an upgrade. People ARE. Apple DOESN’T. Try that take again.")
            status = "Your turn to retry"
        case 2:
            append("You", "People are overreacting because Apple doesn't really change much.")
            append("Nobody", "Your sentence got a bigger upgrade than the phone. What would Apple actually have to change to get your money?")
            status = "Conversation continues"
        default:
            append("You", "Maybe if it felt more คุ้มค่า—you know?")
            append("Nobody", "You switched to Thai like English just asked for your credit card. ‘Worth the money.’ Fine—what would make this rectangle worth yours?")
            status = "English + Thai sample"
        }
    }

    func toggleMute() {
        isMuted.toggle()
        voice?.setMuted(isMuted)
    }

    func end() {
        guard phase == .active || phase == .connecting else { return }
        if !isMock {
            if phase == .connecting {
                goHome()
            } else {
                phase = .saving
                status = "Finishing your learning receipt…"
                liveTask = Task { [weak self] in
                    guard let self else { return }
                    let captureComplete = await self.voice?.finishCapture {
                        self.messages.map { ["speaker": $0.speaker, "text": $0.text] }
                    } ?? false
                    self.voice?.stop()
                    self.voice = nil
                    guard !Task.isCancelled, self.phase == .saving else { return }
                    guard captureComplete else {
                        self.failLive("Nobody couldn’t finish collecting this call’s learning evidence. No receipt was saved. Please start another call.")
                        return
                    }
                    await self.saveLive()
                }
            }
            return
        }
        let signals: [LearningSignal] = mockStep > 0 ? [LearningSignal(
            kind: "grammar", signal: "Subject–verb agreement",
            originalQuote: "People is overreacting because Apple don't really change much.",
            nativeAlternative: "People are overreacting because Apple doesn't really change much.",
            retryQuote: mockStep > 1 ? "People are overreacting because Apple doesn't really change much." : "",
            improvementObserved: mockStep > 1
        )] : []
        receipt = LearningReceipt(id: UUID().uuidString, createdAt: Date().ISO8601Format(),
            topic: topicTitle, signals: signals,
            usefulExpression: mockStep > 2 ? "Worth the money" : "",
            culturalTakeaway: mockStep > 0 ? "An upgrade can be a status signal as well as a practical choice." : "",
            isMock: true)
        phase = .receipt
    }

    func goHome() {
        liveTask?.cancel()
        liveTask = nil
        generation = nil
        voice?.stop()
        voice = nil
        phase = .home
        isMuted = false
        messages = []
        candidates = []
        itemOrder = []
        interruptedAssistantIDs = []
        canRetrySave = false
        if !isMock { Task { await refreshMemory() } }
    }

    func openReceipt(_ receipt: LearningReceipt) {
        self.receipt = receipt
        errorMessage = nil
        phase = .receipt
    }

    private func append(_ speaker: String, _ text: String) {
        messages.append(ConversationLine(id: UUID().uuidString, speaker: speaker, text: text))
    }

    private func startLive() {
        guard let backend else {
            phase = .failed
            errorMessage = "Run the local demo setup to configure secure call access."
            return
        }
        let token = UUID()
        generation = token
        callID = UUID().uuidString
        callCreatedAt = Date().ISO8601Format()
        candidates = []
        itemOrder = []
        interruptedAssistantIDs = []
        phase = .connecting
        status = "Remembering your previous calls…"
        liveTask = Task { [weak self] in
            guard let self else { return }
            do {
                let bootstrap = try await backend.start()
                guard self.generation == token, !Task.isCancelled else { return }
                self.savedReceipts = bootstrap.receipts
                self.showMemory(bootstrap.memory)
                let client = HiggsVoiceClient()
                self.voice = client
                client.onEvent = { [weak self] event in
                    guard let self, self.generation == token else { return }
                    self.receive(event)
                }
                self.status = "Connecting to Higgs…"
                try await client.start(secret: bootstrap.secret, instructions: bootstrap.instructions, tools: bootstrap.tools)
            } catch {
                guard self.generation == token, !Task.isCancelled else { return }
                self.failLive("Couldn’t start the call. \(error.localizedDescription)")
            }
        }
    }

    private func receive(_ event: HiggsEvent) {
        switch event {
        case let .itemOrder(id):
            if !itemOrder.contains(id) { itemOrder.append(id) }
        case let .assistantInterrupted(id):
            interruptedAssistantIDs.insert(id)
            messages.removeAll { $0.id == id }
        case .connected:
            guard phase == .connecting else { return }
            phase = .active
            status = "Nobody is here"
        case let .userTranscript(id, text):
            upsertLine(id: id, speaker: "You", text: text)
        case let .assistantTranscript(id, text):
            upsertLine(id: id, speaker: "Nobody", text: text)
        case let .toolCall(id, name, arguments):
            guard name == "capture_learning", let data = arguments.data(using: .utf8),
                  let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            candidates.append(object)
            let client = voice
            Task {
                try? await client?.sendToolResult(callID: id, result: "{\"status\":\"candidate_received\",\"saved\":false}")
            }
        case .speechStarted:
            if phase == .active { status = "Listening" }
        case .speaking:
            if phase == .active { status = "Nobody has thoughts" }
        case .listening:
            if phase == .active { status = "Your turn" }
        case let .failure(message):
            if phase != .saving { failLive(message) }
        }
    }

    private func upsertLine(id: String, speaker: String, text: String) {
        guard !interruptedAssistantIDs.contains(id) else { return }
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        if let index = messages.firstIndex(where: { $0.id == id }) {
            messages[index] = ConversationLine(id: id, speaker: speaker, text: text)
        } else {
            messages.append(ConversationLine(id: id, speaker: speaker, text: text))
        }
        messages.sort { (itemOrder.firstIndex(of: $0.id) ?? Int.max) < (itemOrder.firstIndex(of: $1.id) ?? Int.max) }
    }

    func retrySave() {
        guard canRetrySave, phase == .failed else { return }
        phase = .saving
        liveTask = Task { await saveLive() }
    }

    private func saveLive() async {
        guard let backend else { return }
        guard messages.contains(where: { $0.speaker == "You" }) else {
            canRetrySave = false
            failLive("No learner speech was captured. No learning was saved. Start another call and speak after Nobody's opening.")
            return
        }
        do {
            let result = try await backend.save(id: callID, createdAt: callCreatedAt, topic: topicTitle, transcript: messages, candidates: candidates)
            guard !Task.isCancelled, phase == .saving else { return }
            receipt = result.receipt
            savedReceipts.removeAll { $0.id == result.receipt.id }
            savedReceipts.insert(result.receipt, at: 0)
            showMemory(result.memory)
            errorMessage = result.warnings?.isEmpty == false ? result.warnings?.joined(separator: " ") : nil
            status = "Saved in InsForge"
            canRetrySave = false
            generation = nil
            phase = .receipt
        } catch {
            guard !Task.isCancelled else { return }
            canRetrySave = true
            if case let DemoBackendError.requestFailed(status, _) = error, (400..<500).contains(status) {
                canRetrySave = false
            }
            phase = .failed
            errorMessage = "The call ended, but no save was confirmed. \(error.localizedDescription)"
        }
    }

    private func failLive(_ message: String) {
        voice?.stop()
        voice = nil
        generation = nil
        phase = .failed
        status = "Call unavailable"
        errorMessage = message
    }

    private func showMemory(_ memory: [LearnerMemory]) {
        memorySummary = memory.isEmpty ? "First call · no previous learning signals" : "Retrieved from InsForge: " + memory.prefix(3).map(\.signal).joined(separator: " · ")
    }
}
