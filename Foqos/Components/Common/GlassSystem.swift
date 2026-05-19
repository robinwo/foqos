import SwiftUI

struct GlassPageBackground: View {
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    ZStack {
      LinearGradient(
        colors: baseGradientColors,
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()

      RadialGradient(
        colors: [
          themeManager.themeColor.opacity(colorScheme == .dark ? 0.1 : 0.08),
          .clear,
        ],
        center: .topLeading,
        startRadius: 30,
        endRadius: 340
      )
      .ignoresSafeArea()
      .offset(x: -80, y: -100)

      Ellipse()
        .fill(Color.white.opacity(colorScheme == .dark ? 0.03 : 0.32))
        .frame(width: 420, height: 220)
        .blur(radius: 50)
        .offset(x: 120, y: -300)

      Ellipse()
        .fill(Color.black.opacity(colorScheme == .dark ? 0.18 : 0.035))
        .frame(width: 500, height: 260)
        .blur(radius: 80)
        .offset(x: -140, y: 420)

      Rectangle()
        .fill(
          LinearGradient(
            colors: [
              Color.white.opacity(colorScheme == .dark ? 0.015 : 0.16),
              .clear,
              Color.black.opacity(colorScheme == .dark ? 0.08 : 0.02),
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .blendMode(.softLight)
        .ignoresSafeArea()
    }
  }

  private var baseGradientColors: [Color] {
    if colorScheme == .dark {
      return [
        Color(hex: "#171513"),
        Color(hex: "#211d19"),
        Color(hex: "#2b2622"),
      ]
    }

    return [
      Color(hex: "#f3efe8"),
      Color(hex: "#ece6dd"),
      Color(hex: "#e6dfd5"),
    ]
  }
}

struct GlassSurfaceModifier: ViewModifier {
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.colorScheme) private var colorScheme

  let cornerRadius: CGFloat
  let tint: Color?
  let strokeOpacity: Double
  let shadowOpacity: Double

  func body(content: Content) -> some View {
    let surfaceTint = tint ?? themeManager.themeColor

    content
      .background(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .fill(baseSurfaceColor)
      )
      .background(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .fill(.ultraThinMaterial.opacity(colorScheme == .dark ? 0.5 : 0.55))
      )
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .fill(
            LinearGradient(
              colors: [
                .white.opacity(colorScheme == .dark ? 0.08 : 0.24),
                .clear,
                surfaceTint.opacity(colorScheme == .dark ? 0.08 : 0.04),
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .blendMode(.softLight)
      )
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .strokeBorder(
            LinearGradient(
              colors: [
                .white.opacity(colorScheme == .dark ? 0.12 : 0.42),
                surfaceTint.opacity(strokeOpacity * 0.65),
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1
          )
      )
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .strokeBorder(
            Color.black.opacity(colorScheme == .dark ? 0.14 : 0.04),
            lineWidth: 0.5
          )
          .blur(radius: 0.5)
      )
      .shadow(
        color: Color.black.opacity(colorScheme == .dark ? shadowOpacity * 1.2 : shadowOpacity),
        radius: 22,
        x: 0,
        y: 12
      )
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
  }

  private var baseSurfaceColor: Color {
    if colorScheme == .dark {
      return Color.white.opacity(0.04)
    }

    return Color(hex: "#fbf8f2").opacity(0.86)
  }
}

extension View {
  func glassSurface(
    cornerRadius: CGFloat = 24,
    tint: Color? = nil,
    strokeOpacity: Double = 0.18,
    shadowOpacity: Double = 0.08
  ) -> some View {
    modifier(
      GlassSurfaceModifier(
        cornerRadius: cornerRadius,
        tint: tint,
        strokeOpacity: strokeOpacity,
        shadowOpacity: shadowOpacity
      )
    )
  }
}
