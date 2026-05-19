import FamilyControls
import SwiftUI

struct AuthorizationCallout: View {
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.colorScheme) private var colorScheme

  let authorizationStatus: AuthorizationStatus
  let onAuthorizationHandler: () -> Void

  private var isAuthorized: Bool {
    authorizationStatus == .approved
  }

  var body: some View {
    Group {
      if !isAuthorized {
        Button(action: onAuthorizationHandler) {
          HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.shield.fill")
              .font(.subheadline.weight(.semibold))
              .foregroundStyle(Color(red: 0.69, green: 0.33, blue: 0.19))
              .padding(.horizontal, 10)
              .padding(.vertical, 8)
              .background(
                Capsule(style: .continuous)
                  .fill(
                    Color(red: 0.96, green: 0.88, blue: 0.76)
                      .opacity(colorScheme == .dark ? 0.28 : 0.8)
                  )
              )

            VStack(alignment: .leading, spacing: 4) {
              Text("Authorization required")
                .font(.headline)
                .foregroundStyle(.primary)

              Text("Authorize Family Controls to enable blocking.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

              HStack(spacing: 6) {
                Text("Tap to authorize")
                  .font(.caption)
                  .fontWeight(.semibold)
                  .foregroundStyle(themeManager.themeColor)

                Image(systemName: "chevron.right")
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
              .padding(.top, 6)
            }

            Spacer(minLength: 0)
          }
          .padding(16)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(calloutBackground)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Authorization required")
        .accessibilityHint("Tap to authorize Family Controls")
      }
    }
  }

  private var calloutBackground: some View {
    RoundedRectangle(cornerRadius: 24, style: .continuous)
      .fill(.clear)
      .glassSurface(
        cornerRadius: 24,
        tint: themeManager.themeColor,
        strokeOpacity: 0.08,
        shadowOpacity: 0.05
      )
  }
}

#Preview {
  VStack(spacing: 20) {
    AuthorizationCallout(
      authorizationStatus: .denied,
      onAuthorizationHandler: {}
    )
    .environmentObject(ThemeManager.shared)

    AuthorizationCallout(
      authorizationStatus: .approved,
      onAuthorizationHandler: {}
    )
    .environmentObject(ThemeManager.shared)
  }
}
