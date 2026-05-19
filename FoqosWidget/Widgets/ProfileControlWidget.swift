//
//  ProfileControlWidget.swift
//  FoqosWidget
//
//  Created by Ali Waseem on 2025-03-11.
//

import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Widget Configuration
struct ProfileControlWidget: Widget {
  let kind: String = "ProfileControlWidget"

  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind, intent: ProfileSelectionIntent.self, provider: ProfileControlProvider()
    ) { entry in
      ProfileWidgetEntryView(entry: entry)
        .containerBackground(for: .widget) {
          if entry.isPauseActive {
            Color(red: 0.82, green: 0.76, blue: 0.65)
          } else if entry.isBreakActive {
            Color(red: 0.79, green: 0.69, blue: 0.6)
          } else if entry.isSessionActive {
            Color(red: 0.56, green: 0.6, blue: 0.54)
          } else {
            Color(red: 0.93, green: 0.9, blue: 0.85)
          }
        }
    }
    .configurationDisplayName("Pause Profile")
    .description("Monitor and control your selected focus profile")
    .supportedFamilies([.systemSmall, .accessoryRectangular, .accessoryInline])
  }
}
