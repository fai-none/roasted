import SwiftUI

enum NobodyTheme {
    static let background = Color.white
    static let surface = Color(white: 0.96)
    static let ink = Color(white: 0.08)
    static let secondary = Color(white: 0.43)
    static let accent = Color(red: 225.0 / 255, green: 18.0 / 255, blue: 71.0 / 255)
    static let border = Color(white: 0.88)
}

struct NobodyAvatar: View {
    var size: CGFloat = 40

    var body: some View {
        Image("NobodyMascot")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .accessibilityHidden(true)
    }
}

struct NobodyActionStyle: ButtonStyle {
    var filled = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minHeight: 44)
            .foregroundStyle(filled ? Color.white : NobodyTheme.accent)
            .background(filled ? NobodyTheme.accent : NobodyTheme.background,
                        in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(NobodyTheme.accent.opacity(filled ? 0 : 0.5), lineWidth: 1.5)
            }
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
