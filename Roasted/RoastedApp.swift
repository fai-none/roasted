import SwiftUI
import UIKit

@main
struct RoastedApp: App {
    @State private var session = CallSession()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            HomeView(session: session)
                .preferredColorScheme(.light)
                .task { await session.refreshMemory() }
                .onChange(of: session.phase) { _, _ in
                    updateIdleTimer()
                }
                .onChange(of: scenePhase) { _, phase in
                    updateIdleTimer()
                    if phase == .background && (session.phase == .active || session.phase == .connecting) {
                        session.end()
                    }
                }
        }
    }

    private func updateIdleTimer() {
        let callInProgress = session.phase == .connecting || session.phase == .active || session.phase == .saving
        UIApplication.shared.isIdleTimerDisabled = scenePhase == .active && !session.isMock && callInProgress
    }
}
