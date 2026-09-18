import SwiftUI

@main
struct RoastedApp: App {
    @State private var session = CallSession()

    var body: some Scene {
        WindowGroup {
            HomeView(session: session)
                .preferredColorScheme(.light)
        }
    }
}
