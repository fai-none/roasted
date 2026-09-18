import SwiftUI

@main
struct RoastedApp: App {
    @State private var session = CallSession()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            HomeView(session: session)
                .preferredColorScheme(.light)
                .task { await session.refreshMemory() }
                .onChange(of: scenePhase) { _, phase in
                    if phase == .background && (session.phase == .active || session.phase == .connecting) {
                        session.end()
                    }
                }
        }
    }
}
