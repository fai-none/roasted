import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Roasted")
                .font(.largeTitle.bold())
            Text("Your English. Well done.")
                .font(.title3)
            Text("Nobody will see you shortly.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .accessibilityIdentifier("roasted-home")
    }
}
