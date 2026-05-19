import SwiftUI

struct BlockedProfileDomainSelector: View {
  @EnvironmentObject var themeManager: ThemeManager

  var domains: [String]
  var buttonAction: () -> Void
  var allowMode: Bool = false
  var disabled: Bool = false
  var disabledText: String?

  private var title: String {
    return allowMode ? "Allowed" : "Blocked"
  }

  private var domainCount: Int {
    return domains.count
  }

  private var buttonText: String {
    return allowMode
      ? "Select Domains to Allow"
      : "Select Domains to Restrict"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Button(action: buttonAction) {
        HStack {
          VStack(alignment: .leading, spacing: 3) {
            Text(buttonText)
              .foregroundStyle(disabled ? .secondary : themeManager.themeColor)
              .font(.subheadline.weight(.semibold))
            Text(title + " domains")
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
      } else if domainCount == 0 {
        Text("No domains selected")
          .font(.footnote)
          .foregroundStyle(.secondary)
      } else {
        Text(
          "\(domainCount) \(domainCount == 1 ? "domain" : "domains") selected"
        )
        .font(.footnote)
        .foregroundStyle(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  VStack(spacing: 20) {
    BlockedProfileDomainSelector(
      domains: ["example.com", "test.org"],
      buttonAction: {}
    )

    BlockedProfileDomainSelector(
      domains: [],
      buttonAction: {},
      allowMode: true
    )

    BlockedProfileDomainSelector(
      domains: ["example.com"],
      buttonAction: {},
      disabled: true,
      disabledText: "Disable the current session to edit domains"
    )
  }
  .padding()
}
