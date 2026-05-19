import SwiftUI

struct BlockingStrategyActionView: View {
  var customView: (any View)?

  var body: some View {
    ZStack {
      GlassPageBackground()

      VStack {
        if let customViewToDisplay = customView {
          AnyView(customViewToDisplay)
        }
      }
      .padding()
    }
    .presentationDetents([.medium])
  }
}
