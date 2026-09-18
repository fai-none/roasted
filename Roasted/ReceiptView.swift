import SwiftUI

struct ReceiptView: View {
    @Bindable var session: CallSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    NobodyAvatar(size: 58)
                    Spacer()
                    if session.receipt?.isMock == true {
                        Text("SAMPLE RECEIPT").font(.caption2.bold())
                            .foregroundStyle(NobodyTheme.accent)
                    }
                }
                Text("YOU SURVIVED\nTODAY’S ROAST")
                    .font(.system(size: 29, weight: .heavy, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)

                if let receipt = session.receipt {
                    Text(receipt.topic)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(NobodyTheme.secondary)
                    provenance(receipt)

                    if receipt.signals.isEmpty {
                        receiptCard("No learning signals captured", text: "No verified correction was captured for this call.")
                    }
                    ForEach(Array(receipt.signals.enumerated()), id: \.offset) { _, signal in
                        VStack(alignment: .leading, spacing: 9) {
                            Label("Sound more natural", systemImage: "character.bubble").font(.subheadline.bold())
                            Text("“\(signal.originalQuote)”")
                                .foregroundStyle(NobodyTheme.secondary)
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "arrow.right")
                                    .foregroundStyle(NobodyTheme.accent)
                                    .accessibilityLabel("Say instead")
                                Text("“\(signal.nativeAlternative)”").fontWeight(.semibold)
                            }
                            if !signal.retryQuote.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Label(signal.improvementObserved ? "You got it on the retry" : "Your retry", systemImage: signal.improvementObserved ? "checkmark.circle.fill" : "arrow.clockwise")
                                        .foregroundStyle(NobodyTheme.accent)
                                    Text("“\(signal.retryQuote)”")
                                        .foregroundStyle(NobodyTheme.secondary)
                                }
                                .font(.caption)
                                .padding(.top, 3)
                            }
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(NobodyTheme.surface, in: RoundedRectangle(cornerRadius: 18))
                    }
                    if let culture = nonempty(receipt.cultureLabel) {
                        VStack(alignment: .leading, spacing: 7) {
                            Label("Culture unlocked", systemImage: "brain").font(.subheadline.bold())
                            Text(culture).font(.subheadline.weight(.semibold))
                            if !receipt.culturalTakeaway.isEmpty {
                                Text("“\(receipt.culturalTakeaway)”")
                                    .font(.caption).foregroundStyle(NobodyTheme.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else if !receipt.culturalTakeaway.isEmpty {
                        receiptCard("Culture unlocked", text: receipt.culturalTakeaway, symbol: "brain")
                    }
                    if let weakness = nonempty(receipt.momentOfWeakness) {
                        VStack(alignment: .leading, spacing: 7) {
                            Label("Moment of weakness", systemImage: "flame").font(.subheadline.bold())
                            Text(weakness).font(.subheadline)
                            if let quote = nonempty(receipt.momentOfWeaknessQuote) {
                                Text("“\(quote)”").font(.caption)
                                    .foregroundStyle(NobodyTheme.secondary)
                            }
                        }
                    }
                    if !receipt.usefulExpression.isEmpty {
                        receiptCard("Keep this expression", text: receipt.usefulExpression)
                    }
                    if let roast = nonempty(receipt.closingRoast) {
                        Text("“\(roast)”")
                            .font(.subheadline).italic()
                            .foregroundStyle(NobodyTheme.accent)
                            .padding(.vertical, 4)
                    }
                } else {
                    receiptCard("No receipt available", text: "No learning signals have been captured for this call.")
                }
                Button(action: session.goHome) {
                    Text("Back to Nobody").frame(maxWidth: .infinity)
                }
                .buttonStyle(NobodyActionStyle(filled: true))
                .accessibilityIdentifier("roasted-receipt-home")
            }
            .padding(24)
        }
        .foregroundStyle(NobodyTheme.ink)
        .background(NobodyTheme.background)
        .accessibilityIdentifier("roasted-receipt")
    }

    @ViewBuilder
    private func provenance(_ receipt: LearningReceipt) -> some View {
        if receipt.isMock {
            Label("Sample conversation. Not saved to learner memory.", systemImage: "info.circle")
                .font(.caption).foregroundStyle(NobodyTheme.secondary)
        } else {
            Label("Saved in InsForge", systemImage: "checkmark.circle.fill")
                .font(.caption).foregroundStyle(NobodyTheme.accent)
            if let warning = session.errorMessage {
                Text(warning).font(.caption).foregroundStyle(NobodyTheme.secondary)
            }
        }
    }

    private func receiptCard(_ title: String, text: String, symbol: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            if let symbol {
                Label(title, systemImage: symbol).font(.subheadline.bold())
            } else {
                Text(title).font(.subheadline.bold())
            }
            Text(text).font(.subheadline).foregroundStyle(NobodyTheme.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func nonempty(_ value: String?) -> String? {
        guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return value
    }
}
