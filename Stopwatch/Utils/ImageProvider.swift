import SwiftUI

struct AppImage: View {
    let name: String
    var renderingMode: Image.TemplateRenderingMode? = nil

    init(_ name: String, renderingMode: Image.TemplateRenderingMode? = nil) {
        self.name = name
        self.renderingMode = renderingMode
    }

    var body: some View {
        if let _ = UIImage(named: name) {
            if let mode = renderingMode {
                Image(name).renderingMode(mode).resizable()
            } else {
                Image(name).resizable()
            }
        } else {
            PlaceholderImage(name: name)
        }
    }
}

struct PlaceholderImage: View {
    let name: String

    var body: some View {
        switch name {
        case "ic_logo":
            logoPlaceholder
        case let s where s.hasPrefix("slider_"):
            sliderPlaceholder(index: Int(name.suffix(1)) ?? 1)
        default:
            Color(AppTheme.surface)
        }
    }

    private var logoPlaceholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.primaryLight)
            Text("KEVILTON")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private func sliderPlaceholder(index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryVariant],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 16) {
                Image(systemName: sliderIcon(for: index))
                    .font(.system(size: 80))
                    .foregroundColor(.white.opacity(0.8))

                Text(sliderTitle(for: index))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }

    private func sliderIcon(for index: Int) -> String {
        switch index {
        case 1: return "lightbulb.fill"
        case 2: return "homekit"
        case 3: return "sparkles"
        default: return "house.fill"
        }
    }

    private func sliderTitle(for index: Int) -> String {
        switch index {
        case 1: return "Smart Lighting"
        case 2: return "Home Automation"
        case 3: return "Energy Saving"
        default: return "Smart Home"
        }
    }
}

extension Image {
    static func appImage(_ name: String) -> Image {
        if UIImage(named: name) != nil {
            return Image(name)
        }
        return Image(systemName: "photo")
    }
}
