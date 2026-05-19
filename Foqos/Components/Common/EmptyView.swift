import SwiftUI

struct EmptyView: View {
  @EnvironmentObject var themeManager: ThemeManager

  let iconName: String
  let headingText: String

  var body: some View {
    VStack {
      Spacer()

      VStack(spacing: 18) {
        Image(systemName: iconName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 72, height: 72)
          .foregroundStyle(themeManager.themeColor.opacity(0.9))
          .padding(18)
          .background(
            Capsule(style: .continuous)
              .fill(.white.opacity(0.16))
          )

        Text(headingText)
          .font(.headline)
          .multilineTextAlignment(.center)
          .foregroundColor(.secondary)
      }
      .padding(28)
      .glassSurface(cornerRadius: 28, strokeOpacity: 0.08, shadowOpacity: 0.05)
      .padding(.horizontal, 24)

      Spacer()
    }
  }
}

#Preview {
  EmptyView(iconName: "tray", headingText: "No items in your list")
    .environmentObject(ThemeManager.shared)
}
