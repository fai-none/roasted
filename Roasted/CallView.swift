import SwiftUI

struct CallView: View {
    @Bindable var session: CallSession
    @State private var sampleStep = 0

    var body: some View {
        VStack(spacing: 0) {
            if session.phase == .incoming {
                incoming
            } else {
                active
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background(NobodyTheme.accent.ignoresSafeArea())
        .accessibilityIdentifier("roasted-call")
    }

    private var incoming: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(session.isMock ? "MOCK INCOMING CALL" : "INCOMING CALL")
                .font(.caption.weight(.bold))
                .tracking(2)
            NobodyAvatar(size: 180)
            Text("Nobody").font(.system(size: 44, weight: .bold, design: .rounded))
            Text("Has opinions about your opinions.")
                .font(.title3)
            Text(session.topicTitle)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .opacity(0.85)
                .padding(.horizontal, 28)
            Spacer()
            HStack(spacing: 65) {
                incomingAction("Decline", image: "phone.down.fill", color: .white.opacity(0.2), identifier: "roasted-decline-call", action: session.decline)
                incomingAction("Accept", image: "phone.fill", color: Color(red: 0.12, green: 0.68, blue: 0.37), identifier: "roasted-accept-call", action: session.accept)
            }
            Text("An in-app call · English + Thai")
                .font(.caption)
                .opacity(0.8)
                .padding(.top, 15)
        }
        .padding(.vertical, 35)
    }

    private var active: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                NobodyAvatar(size: 62)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Nobody").font(.title2.bold())
                    Text(session.status).font(.caption)
                }
                Spacer()
                if session.isMock {
                    Text("MOCK").font(.caption2.bold())
                        .padding(8).background(.white.opacity(0.18), in: Capsule())
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 16)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if session.messages.isEmpty {
                            Text(session.phase == .saving ? "Saving your learning receipt…" : "Getting the conversation ready…")
                                .font(.subheadline).padding(18)
                        }
                        ForEach(session.messages) { line in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(line.speaker.uppercased()).font(.caption2.bold())
                                    .foregroundStyle(line.speaker == "You" ? NobodyTheme.secondary : NobodyTheme.accent)
                                Text(line.text).font(.body)
                                    .foregroundStyle(NobodyTheme.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(line.speaker == "You" ? Color.white.opacity(0.88) : .white,
                                        in: RoundedRectangle(cornerRadius: 18))
                            .padding(.leading, line.speaker == "You" ? 24 : 0)
                            .padding(.trailing, line.speaker == "You" ? 0 : 16)
                            .id(line.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }
                .onChange(of: session.messages.count) { _, _ in
                    if let last = session.messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            if session.isMock && session.phase == .active && sampleStep < 3 {
                Button {
                    sampleStep += 1
                    session.advanceMock()
                } label: {
                    Label(sampleActionTitle, systemImage: "play.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.vertical, 11).padding(.horizontal, 18)
                        .background(.white.opacity(0.18), in: Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("roasted-advance-sample")
            }
            if session.phase == .failed {
                if let message = session.errorMessage {
                    Text(message).font(.callout).multilineTextAlignment(.center).padding(.horizontal)
                }
                Button("Back home", action: session.goHome)
                    .font(.headline).padding()
                    .accessibilityIdentifier("roasted-error-home")
            } else if session.phase == .saving {
                ProgressView().tint(.white).padding()
            } else {
                CallControlsView(isMuted: session.isMuted, errorMessage: session.errorMessage,
                                 onToggleMute: session.toggleMute, onEnd: session.end)
                    .padding(.bottom, 16)
            }
        }
    }

    private var sampleActionTitle: String {
        switch sampleStep {
        case 0: "Play sample opinion + roast"
        case 1: "Play sample retry"
        default: "Play Thai code-switch"
        }
    }

    private func incomingAction(_ title: String, image: String, color: Color, identifier: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: image).font(.title.weight(.semibold))
                    .frame(width: 76, height: 76).background(color, in: Circle())
                Text(title).font(.subheadline.weight(.semibold))
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
    }
}
