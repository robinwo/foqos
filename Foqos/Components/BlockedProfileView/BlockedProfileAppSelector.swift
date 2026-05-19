import FamilyControls
import SwiftUI

struct BlockedProfileAppSelector: View {
  @EnvironmentObject var themeManager: ThemeManager

  var selection: FamilyActivitySelection
  var buttonAction: () -> Void
  var allowMode: Bool = false
  var disabled: Bool = false
  var disabledText: String?

  private var title: String {
    return allowMode ? "Allowed" : "Blocked"
  }

  private var catAndAppCount: Int {
    return FamilyActivityUtil.countSelectedActivities(selection, allowMode: allowMode)
  }

  private var countDisplayText: String {
    return FamilyActivityUtil.getCountDisplayText(selection, allowMode: allowMode)
  }

  private var shouldShowWarning: Bool {
    return FamilyActivityUtil.shouldShowAllowModeWarning(selection, allowMode: allowMode)
  }

  private var buttonText: String {
    return allowMode
      ? "Select Apps to Allow"
      : "Select Apps to Restrict"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Button(action: buttonAction) {
        HStack {
          VStack(alignment: .leading, spacing: 3) {
            Text(buttonText)
              .foregroundStyle(disabled ? .secondary : themeManager.themeColor)
              .font(.subheadline.weight(.semibold))
            Text(title + " apps")
              .font(.caption)
              .foregroundStyle(.secondary)
          }

          Spacer()
          Image(systemName: "chevron.right")
            .foregroundStyle(.gray)
        }
      }
      .disabled(disabled)
      .padding(.horizontal, 14)
      .padding(.vertical, 12)
      .glassSurface(
        cornerRadius: 18,
        tint: themeManager.themeColor,
        strokeOpacity: 0.08,
        shadowOpacity: 0.03
      )

      if let disabledText = disabledText, disabled {
        Text(disabledText)
          .foregroundStyle(.red)
          .font(.caption)
      } else if catAndAppCount == 0 {
        Text("No apps selected")
          .font(.footnote)
          .foregroundStyle(.secondary)
      } else {
        VStack(alignment: .leading, spacing: 4) {
          Text("\(countDisplayText) selected")
            .font(.footnote)
            .foregroundStyle(.secondary)

          if shouldShowWarning {
            Text("Allow mode: Categories expand to individual apps (50 limit applies)")
              .font(.caption)
              .foregroundColor(.orange)
          }
        }
      }
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  BlockedProfileAppSelector(
    selection: FamilyActivitySelection(),
    buttonAction: {},
    disabled: true,
    disabledText: "Disable the current session to edit apps for blocking"
  )

  BlockedProfileAppSelector(
    selection: FamilyActivitySelection(),
    buttonAction: {},
    allowMode: true,
    disabled: true,
    disabledText: "Disable the current session to edit apps for blocking"
  )
}
