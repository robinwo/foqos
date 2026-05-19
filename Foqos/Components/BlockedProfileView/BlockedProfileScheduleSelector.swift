import SwiftUI

struct BlockedProfileScheduleSelector: View {
  @EnvironmentObject var themeManager: ThemeManager

  var schedule: BlockedProfileSchedule
  var buttonAction: () -> Void
  var disabled: Bool = false
  var disabledText: String?

  private var buttonText: String { "Set schedule" }

  private var daysCount: Int { schedule.days.count }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Button(action: buttonAction) {
        HStack {
          VStack(alignment: .leading, spacing: 3) {
            Text(buttonText)
              .foregroundStyle(disabled ? .secondary : themeManager.themeColor)
              .font(.subheadline.weight(.semibold))
            Text("Recurring schedule")
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
      } else if daysCount == 0 {
        Text("No schedule set")
          .font(.footnote)
          .foregroundStyle(.secondary)
      } else {
        Text(schedule.summaryText)
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  VStack(spacing: 20) {
    BlockedProfileScheduleSelector(
      schedule: .init(
        days: [.monday, .wednesday, .friday], startHour: 9, startMinute: 0, endHour: 17,
        endMinute: 0, updatedAt: Date()),
      buttonAction: {}
    )

    BlockedProfileScheduleSelector(
      schedule: .init(
        days: [], startHour: 9, startMinute: 0, endHour: 17, endMinute: 0, updatedAt: Date()),
      buttonAction: {},
      disabled: true,
      disabledText: "Disable the current session to edit schedule"
    )
  }
  .padding()
}
