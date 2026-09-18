import SwiftUI

struct HomeView: View {
    @Bindable var session: CallSession

    var body: some View {
        Group {
            switch session.phase {
            case .home: home
            case .receipt: ReceiptView(session: session)
            case .incoming, .connecting, .active, .saving, .failed:
                CallView(session: session)
            }
        }
        .preferredColorScheme(.light)
    }

    private var home: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                HStack {
                    Text("Roasted").font(.largeTitle.bold())
                    Spacer()
                    if session.isMock { sampleBadge }
                    else { Text("HIGGS LIVE").font(.caption2.bold()).foregroundStyle(NobodyTheme.accent) }
                }
                VStack(alignment: .leading, spacing: 12) {
                    NobodyAvatar(size: 116)
                    Text("Your English.\nWell done.")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                    Text("A hot take. A little roasting. Better English.")
                        .font(.body)
                        .foregroundStyle(NobodyTheme.secondary)
                }
                VStack(alignment: .leading, spacing: 14) {
                    Text(session.isMock ? "SAMPLE TOPIC" : "TODAY’S CONVERSATION")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(NobodyTheme.accent)
                    Text(session.topicTitle).font(.title2.bold())
                    Text(session.topicContext)
                        .font(.subheadline)
                        .foregroundStyle(NobodyTheme.secondary)
                    HStack {
                        Text(session.topicDate).foregroundStyle(NobodyTheme.secondary)
                        Spacer()
                        Link(session.topicSourceLabel, destination: session.topicSourceURL)
                            .foregroundStyle(NobodyTheme.accent)
                    }
                    .font(.caption2)
                    Button(action: session.ring) {
                        Label("Get roasted", systemImage: "phone.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(NobodyActionStyle(filled: true))
                    .accessibilityIdentifier("roasted-start-call")
                }
                .padding(22)
                .background(NobodyTheme.surface, in: RoundedRectangle(cornerRadius: 24))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Nobody remembers").font(.headline)
                    Text(session.memorySummary)
                        .font(.subheadline)
                        .foregroundStyle(NobodyTheme.secondary)
                    if session.isMock {
                        Text("This is a sample journey. No microphone or saved learner memory is used.")
                            .font(.caption)
                            .foregroundStyle(NobodyTheme.secondary)
                    }
                }
                if !session.savedReceipts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your learning receipts").font(.headline)
                        ForEach(session.savedReceipts) { receipt in
                            Button { session.openReceipt(receipt) } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(receipt.topic).font(.subheadline.weight(.semibold))
                                        Text(receipt.isMock ? "Sample receipt" : "Saved session")
                                            .font(.caption).foregroundStyle(NobodyTheme.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundStyle(NobodyTheme.ink)
                                .padding(16)
                                .background(NobodyTheme.surface, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("roasted-saved-receipt")
                        }
                    }
                }
                if session.liveAvailable {
                    Button(session.isMock ? "Use live Higgs" : "Open mock walkthrough", action: session.toggleDemoMode)
                        .font(.caption)
                        .foregroundStyle(NobodyTheme.secondary)
                }
            }
            .padding(24)
        }
        .background(NobodyTheme.background)
        .foregroundStyle(NobodyTheme.ink)
        .accessibilityIdentifier("roasted-home")
    }

    private var sampleBadge: some View {
        Text("MOCK DEMO")
            .font(.caption2.bold())
            .foregroundStyle(NobodyTheme.accent)
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(NobodyTheme.accent.opacity(0.08), in: Capsule())
    }
}
