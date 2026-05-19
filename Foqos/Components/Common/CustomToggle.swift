import SwiftUI

struct CustomToggle: View {
  @EnvironmentObject var themeManager: ThemeManager

  let title: String
  let description: String
  @Binding var isOn: Bool
  var isDisabled: Bool = false
  var errorMessage: String? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Toggle(isOn: $isOn) {
        VStack(alignment: .leading, spacing: 6) {
          Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary)

          Text(description)
            .font(.caption)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)
            .padding(.trailing, 64)
        }
      }
      .disabled(isDisabled)
      .tint(themeManager.themeColor)

      if isDisabled && errorMessage != nil {
        Text(errorMessage!)
          .font(.caption)
          .foregroundColor(.red)
      }
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 14)
    .glassSurface(
      cornerRadius: 18,
      tint: themeManager.themeColor,
      strokeOpacity: 0.08,
      shadowOpacity: 0.03
    )
    .opacity(isDisabled ? 0.82 : 1)
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 16) {
    CustomToggle(
      title: "Enable Feature",
      description: "This is a description of what this toggle does.",
      isOn: .constant(true)
    )

    CustomToggle(
      title: "Enable Feature",
      description:
        "This is a toggle with a really long description so that it doesn't look so weird and super strange",
      isOn: .constant(false)
    )

    CustomToggle(
      title: "Disabled Toggle",
      description: "This toggle is currently disabled.",
      isOn: .constant(false),
      isDisabled: true
    )
  }
  .padding()
}
