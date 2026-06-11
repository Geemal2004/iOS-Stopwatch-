import SwiftUI

enum AppTheme {
    static let primary = Color(red: 145/255, green: 0/255, blue: 0/255)
    static let primaryVariant = Color(red: 86/255, green: 8/255, blue: 8/255)
    static let primaryLight = Color(red: 180/255, green: 40/255, blue: 40/255)
    static let background = Color.black
    static let surface = Color(white: 0.12)
    static let surfaceLight = Color(white: 0.18)
    static let cardBackground = Color(white: 0.15)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textMuted = Color.white.opacity(0.5)
    static let accent = Color(red: 220/255, green: 50/255, blue: 50/255)
    static let success = Color.green
    static let warning = Color.orange
    static let destructive = Color.red

    static let gradientRed = LinearGradient(
        colors: [primary, primaryVariant],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let gradientDark = LinearGradient(
        colors: [Color.black, Color(white: 0.08)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardGradient = LinearGradient(
        colors: [surfaceLight, surface],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.gradientRed)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .font(.system(size: 18, weight: .semibold))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(AppTheme.textSecondary, lineWidth: 1)
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .font(.system(size: 18, weight: .semibold))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
