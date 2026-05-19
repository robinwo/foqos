import SwiftUI

struct Welcome: View {
  @EnvironmentObject var themeManager: ThemeManager
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      VStack(alignment: .leading, spacing: 18) {
        HStack {
          Text("Focus setup")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)

          Spacer()

          Image(systemName: "hourglass")
            .font(.subheadline.weight(.semibold))
            .foregroundColor(themeManager.themeColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
              Capsule(style: .continuous)
                .fill(themeManager.themeColor.opacity(0.1))
            )
        }

        Text("Make your phone quiet.")
          .font(.system(size: 30, weight: .bold, design: .default))
          .foregroundColor(.primary)
          .fixedSize(horizontal: false, vertical: true)

        Text(
          "Create your first profile to block social media, sites, or other distractions with a physical tap."
        )
        .font(.subheadline)
        .foregroundColor(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      }
      .padding(24)
      .frame(maxWidth: .infinity, minHeight: 176, alignment: .leading)
      .glassSurface(
        cornerRadius: 28,
        tint: themeManager.themeColor,
        strokeOpacity: 0.08,
        shadowOpacity: 0.05
      )
    }
    .buttonStyle(ScaleButtonStyle())
  }
}

struct ScaleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .animation(.spring(response: 0.3), value: configuration.isPressed)
  }
}

#Preview {
  ZStack {
    Color.gray.opacity(0.1).ignoresSafeArea()

    Welcome(onTap: {
      print("Card tapped")
    })
    .padding(.horizontal)
    .environmentObject(ThemeManager.shared)
  }
}
