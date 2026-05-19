import FamilyControls
import SwiftUI

struct ProfileStatsRow: View {
  let selectedActivity: FamilyActivitySelection
  let sessionCount: Int
  let domainsCount: Int

  var body: some View {
    HStack(spacing: 12) {
      statColumn(
        title: "Apps & Categories",
        value: "\(FamilyActivityUtil.countSelectedActivities(selectedActivity))"
      )

      Divider()
        .frame(height: 24)

      statColumn(
        title: "Domains",
        value: "\(domainsCount)"
      )

      Divider()
        .frame(height: 24)

      statColumn(
        title: "Total Sessions",
        value: sessionCount.description.localizedLowercase
      )
    }
  }

  private func statColumn(title: String, value: String) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title)
        .font(.caption)
        .foregroundColor(.secondary)

      Text(value)
        .font(.subheadline)
        .fontWeight(.semibold)
    }
  }
}

#Preview {
  ProfileStatsRow(
    selectedActivity: FamilyActivitySelection(),
    sessionCount: 12,
    domainsCount: 12
  )
  .padding()
  .background(Color(hex: "#f3efe8"))
}
