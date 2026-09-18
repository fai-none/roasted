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
    var isMock = true
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
        phase = .active
        status = "Sample conversation"
        append("Nobody", "A new phone every year? Your camera has a better career plan than you. Is upgrading actually worth it?")
    }

    func advanceMock() {
        guard isMock, phase == .active else { return }
        mockStep += 1
        switch mockStep {
        case 1:
            append("You", "People is overreacting because Apple don't really change much.")
            append("Nobody", "Fair point—the hype is doing the heavy lifting. But ‘people is’ just dropped your grammar down the stairs. Try ‘People are overreacting because Apple doesn't really change much.’")
            status = "Your turn to retry"
        case 2:
            append("You", "People are overreacting because Apple doesn't really change much.")
            append("Nobody", "There we go. Same hot take, fewer grammatical casualties. So what would actually make you upgrade?")
            status = "Conversation continues"
        default:
            append("You", "Maybe if it felt more คุ้มค่า—you know?")
            append("Nobody", "‘Worth the money’—exactly. You want value, not a very expensive new rectangle. What would feel worth the money to you?")
            status = "English + Thai sample"
        }
    }

    func toggleMute() { isMuted.toggle() }

    func end() {
        guard phase == .active || phase == .connecting else { return }
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
        phase = .home
        isMuted = false
        messages = []
    }

    func openReceipt(_ receipt: LearningReceipt) {
        self.receipt = receipt
        phase = .receipt
    }

    private func append(_ speaker: String, _ text: String) {
        messages.append(ConversationLine(id: UUID().uuidString, speaker: speaker, text: text))
    }
}
