import SwiftUI

struct ReceiptView: View {
    @Bindable var session: CallSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    NobodyAvatar(size: 66)
                    Spacer()
                    if session.receipt?.isMock == true {
                        Text("SAMPLE RECEIPT").font(.caption2.bold())
                            .foregroundStyle(NobodyTheme.accent)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Freshly roasted.").font(.largeTitle.bold())
                    Text("Here’s what you can take into your next conversation.")
                        .foregroundStyle(NobodyTheme.secondary)
                }
                if let receipt = session.receipt {
                    Text(receipt.topic).font(.headline)
                    if receipt.isMock {
                        Label("Sample conversation only. This receipt is not saved to learner memory.", systemImage: "info.circle")
                            .font(.caption)
                            .foregroundStyle(NobodyTheme.secondary)
                    }
                    if receipt.signals.isEmpty {
                        receiptCard("No learning signals captured yet", text: "There wasn’t enough conversation to identify an example. A new call gives you another chance.")
                    }
                    ForEach(receipt.signals) { signal in
                        VStack(alignment: .leading, spacing: 14) {
                            Text("WHAT GAVE YOU AWAY").font(.caption.bold())
                                .foregroundStyle(NobodyTheme.accent)
                            Text(signal.signal).font(.headline)
                            Text("“\(signal.originalQuote)”").font(.body)
                                .foregroundStyle(NobodyTheme.secondary)
                            Divider()
                            Text("Say it naturally").font(.caption.bold())
                            Text("“\(signal.nativeAlternative)”").font(.body.weight(.semibold))
                            if !signal.retryQuote.isEmpty {
                                Label(signal.improvementObserved ? "You got it on the retry" : "Your retry", systemImage: signal.improvementObserved ? "checkmark.circle.fill" : "arrow.clockwise")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(NobodyTheme.accent)
                                Text("“\(signal.retryQuote)”").font(.subheadline)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(NobodyTheme.surface, in: RoundedRectangle(cornerRadius: 22))
                    }
                    if !receipt.usefulExpression.isEmpty {
                        receiptCard("Keep this expression", text: receipt.usefulExpression)
                    }
                    if !receipt.culturalTakeaway.isEmpty {
                        receiptCard("The cultural takeaway", text: receipt.culturalTakeaway)
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

    private func receiptCard(_ title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline)
            Text(text).font(.body).foregroundStyle(NobodyTheme.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(NobodyTheme.surface, in: RoundedRectangle(cornerRadius: 22))
    }
}
