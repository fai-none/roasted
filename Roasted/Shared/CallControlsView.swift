import SwiftUI

struct CallControlsView: View {
    let isMuted: Bool
    let isSpeakerEnabled: Bool?
    let showsMute: Bool
    let errorMessage: String?
    let endAccessibilityLabel: String
    let onToggleMute: () -> Void
    let onToggleSpeaker: (() -> Void)?
    let onEnd: () -> Void

    init(
        isMuted: Bool,
        isSpeakerEnabled: Bool? = nil,
        showsMute: Bool = true,
        errorMessage: String? = nil,
        endAccessibilityLabel: String = "End call",
        onToggleMute: @escaping () -> Void,
        onToggleSpeaker: (() -> Void)? = nil,
        onEnd: @escaping () -> Void
    ) {
        self.isMuted = isMuted
        self.isSpeakerEnabled = isSpeakerEnabled
        self.showsMute = showsMute
        self.errorMessage = errorMessage
        self.endAccessibilityLabel = endAccessibilityLabel
        self.onToggleMute = onToggleMute
        self.onToggleSpeaker = onToggleSpeaker
        self.onEnd = onEnd
    }

    var body: some View {
        VStack(spacing: 24) {
            if let errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(12)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    .accessibilityIdentifier("roasted-call-error")
            }

            HStack(spacing: 34) {
                if showsMute {
                    control(
                        title: isMuted ? "Unmute" : "Mute",
                        image: isMuted ? "mic.fill" : "mic.slash.fill",
                        isSelected: isMuted,
                        identifier: "roasted-call-mute",
                        action: onToggleMute
                    )
                }
                if let isSpeakerEnabled, let onToggleSpeaker {
                    control(
                        title: "Speaker",
                        image: isSpeakerEnabled ? "speaker.wave.3.fill" : "speaker.wave.2.fill",
                        isSelected: isSpeakerEnabled,
                        identifier: "roasted-call-speaker",
                        action: onToggleSpeaker
                    )
                }
            }

            Button(action: onEnd) {
                VStack(spacing: 10) {
                    Image(systemName: "phone.down.fill")
                        .font(.title2.weight(.bold))
                        .frame(width: 70, height: 70)
                        .background(Color(red: 1, green: 0.23, blue: 0.19), in: Circle())
                    Text("End call")
                        .font(.callout.weight(.medium))
                }
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(endAccessibilityLabel)
            .accessibilityIdentifier("roasted-call-end")
        }
    }

    private func control(
        title: String,
        image: String,
        isSelected: Bool,
        identifier: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 9) {
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 64, height: 64)
                    .foregroundStyle(isSelected ? NobodyTheme.accent : .white)
                    .background(Color.white.opacity(isSelected ? 1 : 0.22), in: Circle())
                Text(title).font(.callout.weight(.medium))
            }
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
    }
}
