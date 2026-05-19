import SwiftUI

struct StrategyInfoView: View {
  @EnvironmentObject var themeManager: ThemeManager

  let strategyId: String?

  // Get blocking strategy name
  private var blockingStrategyName: String {
    guard let strategyId = strategyId else { return "None" }
    return StrategyManager.getStrategyFromId(id: strategyId).name
  }

  // Get blocking strategy icon
  private var blockingStrategyIcon: String {
    guard let strategyId = strategyId else {
      return "questionmark.circle.fill"
    }
    return StrategyManager.getStrategyFromId(id: strategyId).iconType
  }

  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: blockingStrategyIcon)
        .foregroundColor(themeManager.themeColor)
        .font(.system(size: 13))
        .frame(width: 28, height: 28)
        .background(
          Capsule(style: .continuous)
            .fill(themeManager.themeColor.opacity(0.12))
        )

      VStack(alignment: .leading, spacing: 2) {
        Text(blockingStrategyName)
          .foregroundColor(.primary)
          .font(.subheadline)
          .fontWeight(.medium)
      }
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    StrategyInfoView(strategyId: NFCBlockingStrategy.id)
    StrategyInfoView(strategyId: QRCodeBlockingStrategy.id)
    StrategyInfoView(strategyId: nil)
  }
  .padding()
  .background(Color(hex: "#f3efe8"))
}
