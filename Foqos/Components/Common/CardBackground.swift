import SwiftUI

struct CardBackground: View {
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.colorScheme) private var colorScheme

  var isActive: Bool = false
  var customColor: Color? = nil

  private var cardColor: Color {
    if isActive {
      return themeManager.themeColor.opacity(0.4)
    }

    return customColor ?? themeManager.themeColor
  }

  private var baseColor: Color {
    colorScheme == .dark
      ? Color.white.opacity(0.03)
      : Color(hex: "#faf6ef").opacity(0.72)
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 24)
      .fill(baseColor)
      .overlay(
        GeometryReader { geometry in
          ZStack {
            if isActive {
              TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ActiveAmbientSurface(
                  baseColor: cardColor,
                  t: timeline.date.timeIntervalSinceReferenceDate,
                  size: geometry.size
                )
              }
            } else {
              QuietTintPool(color: cardColor, in: geometry.size)
            }
          }
        }
      )
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .stroke(Color.white.opacity(colorScheme == .dark ? 0.08 : 0.38), lineWidth: 1)
      )
      .glassSurface(cornerRadius: 24, tint: cardColor, strokeOpacity: 0.12, shadowOpacity: 0.07)
      .clipShape(RoundedRectangle(cornerRadius: 24))
  }

  public func getCardColor() -> Color {
    return cardColor
  }

  private struct ActiveAmbientSurface: View {
    let baseColor: Color
    let t: TimeInterval
    let size: CGSize

    var body: some View {
      ZStack {
        QuietTintPool(color: baseColor, in: size)
          .opacity(0.8)

        RadialGradient(
          colors: [
            baseColor.opacity(0.2),
            .clear,
          ],
          center: .center,
          startRadius: 0,
          endRadius: min(size.width, size.height) * 0.6
        )
        .frame(width: size.width * 0.8, height: size.height * 0.8)
        .offset(
          x: CGFloat(cos(t * 0.22)) * 20,
          y: CGFloat(sin(t * 0.18)) * 12
        )
        .blur(radius: 18)

        Ellipse()
          .fill(Color.white.opacity(0.12))
          .frame(width: size.width * 0.65, height: size.height * 0.2)
          .blur(radius: 18)
          .offset(
            x: CGFloat(cos(t * 0.11 + 0.9)) * 18,
            y: -size.height * 0.22
          )
      }
      .allowsHitTesting(false)
    }
  }

  private struct QuietTintPool: View {
    let color: Color
    let size: CGSize

    init(color: Color, in size: CGSize) {
      self.color = color
      self.size = size
    }

    var body: some View {
      ZStack {
        Circle()
          .fill(color.opacity(0.14))
          .frame(width: size.width * 0.56, height: size.width * 0.56)
          .position(x: size.width * 0.86, y: size.height * 0.58)
          .blur(radius: 18)

        Ellipse()
          .fill(Color.white.opacity(0.12))
          .frame(width: size.width * 0.62, height: size.height * 0.18)
          .position(x: size.width * 0.4, y: size.height * 0.18)
          .blur(radius: 16)
      }
      .allowsHitTesting(false)
    }
  }
}

#Preview {
  ZStack {
    Color(.systemGroupedBackground).ignoresSafeArea()

    VStack(spacing: 16) {
      CardBackground(isActive: false, customColor: .orange)
        .frame(height: 170)

      CardBackground(isActive: true, customColor: .blue)
        .frame(height: 170)
    }
    .padding(.horizontal)
  }
  .environmentObject(ThemeManager.shared)
}
