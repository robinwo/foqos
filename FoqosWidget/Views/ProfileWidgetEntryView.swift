import AppIntents
import FamilyControls
import SwiftUI
import WidgetKit

struct ProfileWidgetEntryView: View {
  var entry: ProfileControlProvider.Entry
  @Environment(\.widgetFamily) private var widgetFamily

  private var isUnavailable: Bool {
    guard let selectedProfileId = entry.selectedProfileId,
      let activeSession = entry.activeSession
    else {
      return false
    }

    return activeSession.blockedProfileId.uuidString != selectedProfileId
  }

  private var quickLaunchEnabled: Bool {
    entry.useProfileURL == true
  }

  private var linkToOpen: URL {
    if entry.isBreakActive || entry.isSessionActive {
      return URL(string: "https://foqos.app")!
    }

    return entry.deepLinkURL ?? URL(string: "foqos://")!
  }

  private var blockedCount: Int {
    guard let profile = entry.profileSnapshot else { return 0 }
    let appCount =
      profile.selectedActivity.categories.count + profile.selectedActivity.applications.count
    let webDomainCount = profile.selectedActivity.webDomains.count
    let customDomainCount = profile.domains?.count ?? 0
    return appCount + webDomainCount + customDomainCount
  }

  private var enabledOptionsCount: Int {
    guard let profile = entry.profileSnapshot else { return 0 }

    var count = 0
    if profile.enableLiveActivity { count += 1 }
    if profile.enableBreaks { count += 1 }
    if profile.enableStrictMode { count += 1 }
    if profile.enableAllowMode { count += 1 }
    if profile.enableAllowModeDomains { count += 1 }
    if profile.reminderTimeInSeconds != nil { count += 1 }
    if profile.physicalUnblockItems?.isEmpty == false { count += 1 }
    if profile.schedule != nil { count += 1 }
    if profile.disableBackgroundStops == true { count += 1 }
    return count
  }

  private var profileName: String {
    entry.profileName ?? "No Profile"
  }

  private var accentColor: Color {
    if entry.isPauseActive {
      return Color(red: 0.77, green: 0.57, blue: 0.16)
    }
    if entry.isBreakActive {
      return Color(red: 0.78, green: 0.43, blue: 0.18)
    }
    if entry.isSessionActive {
      return Color(red: 0.33, green: 0.49, blue: 0.39)
    }
    return Color(red: 0.44, green: 0.40, blue: 0.36)
  }

  private var baseBackground: LinearGradient {
    if entry.isSessionActive || entry.isBreakActive || entry.isPauseActive {
      return LinearGradient(
        colors: [
          Color(red: 0.34, green: 0.31, blue: 0.28),
          Color(red: 0.23, green: 0.21, blue: 0.19),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    }

    return LinearGradient(
      colors: [
        Color(red: 0.95, green: 0.93, blue: 0.89),
        Color(red: 0.91, green: 0.88, blue: 0.83),
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  private var primaryTextColor: Color {
    entry.isSessionActive || entry.isBreakActive || entry.isPauseActive
      ? .white
      : Color(red: 0.18, green: 0.17, blue: 0.16)
  }

  private var secondaryTextColor: Color {
    entry.isSessionActive || entry.isBreakActive || entry.isPauseActive
      ? Color.white.opacity(0.78)
      : Color(red: 0.39, green: 0.37, blue: 0.34)
  }

  private var statusLabel: String {
    if entry.isPauseActive { return "Paused" }
    if entry.isBreakActive { return "On a Break" }
    if entry.isSessionActive { return "Active" }
    return "Ready"
  }

  private var statusSymbol: String {
    if entry.isPauseActive { return "pause.circle.fill" }
    if entry.isBreakActive { return "cup.and.saucer.fill" }
    if entry.isSessionActive { return "hourglass.circle.fill" }
    return "sparkles"
  }

  var body: some View {
    switch widgetFamily {
    case .accessoryInline:
      inlineView
    case .accessoryRectangular:
      rectangularView
    default:
      systemSmallView
    }
  }

  private var inlineView: some View {
    Group {
      if entry.isPauseActive {
        Label("Paused", systemImage: "pause.circle.fill")
      } else if entry.isBreakActive {
        Label("On a Break", systemImage: "cup.and.saucer.fill")
      } else if entry.isSessionActive, let startTime = entry.sessionStartTime {
        Label {
          Text(startTime, style: .timer)
        } icon: {
          Image(systemName: "hourglass")
        }
      } else {
        Label(profileName, systemImage: "hourglass")
      }
    }
  }

  private var rectangularView: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(profileName)
          .font(.caption.weight(.semibold))
          .lineLimit(1)

        Spacer(minLength: 8)

        statusCapsule
      }

      if entry.isSessionActive {
        if let startTime = entry.sessionStartTime {
          if entry.profileSnapshot != nil {
            Text("\(blockedCount) blocked • \(enabledOptionsCount) options")
              .font(.caption2)
              .foregroundStyle(.secondary)
          }

          HStack(spacing: 6) {
            Image(
              systemName: entry.isPauseActive
                ? "pause.fill" : entry.isBreakActive ? "cup.and.saucer.fill" : "clock.fill"
            )
            .font(.caption2.weight(.semibold))

            if let countdownRange = countdownRange {
              Text(timerInterval: countdownRange, countsDown: true)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            } else {
              Text(startTime, style: .timer)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            }
          }
        }
      } else {
        Text(
          entry.profileSnapshot == nil
            ? "Select a profile to begin." : "Tap to start a focus session."
        )
        .font(.caption2)
        .foregroundStyle(.secondary)
      }
    }
  }

  private var systemSmallView: some View {
    ZStack {
      baseBackground

      VStack(alignment: .leading, spacing: 12) {
        HStack(alignment: .top) {
          VStack(alignment: .leading, spacing: 6) {
            Text("Pause")
              .font(.caption.weight(.semibold))
              .foregroundStyle(secondaryTextColor)

            Text(profileName)
              .font(.system(size: 16, weight: .bold, design: .rounded))
              .foregroundStyle(primaryTextColor)
              .lineLimit(2)
          }

          Spacer(minLength: 8)

          Image(systemName: "hourglass")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(accentColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
              Capsule(style: .continuous)
                .fill(
                  Color.white.opacity(
                    entry.isSessionActive || entry.isBreakActive || entry.isPauseActive
                      ? 0.14 : 0.42
                  )
                )
            )
        }

        VStack(alignment: .leading, spacing: 6) {
          Text(statusLabel.uppercased())
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .tracking(1)
            .foregroundStyle(secondaryTextColor)

          if entry.isSessionActive, let startTime = entry.sessionStartTime {
            if let countdownRange = countdownRange {
              Text(timerInterval: countdownRange, countsDown: true)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(primaryTextColor)
            } else {
              Text(startTime, style: .timer)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(primaryTextColor)
            }
          } else {
            Text(quickLaunchEnabled ? "Tap to launch" : "Tap to open")
              .font(.system(size: 22, weight: .bold, design: .rounded))
              .foregroundStyle(primaryTextColor)
          }
        }

        Spacer(minLength: 0)

        VStack(alignment: .leading, spacing: 4) {
          if entry.profileSnapshot != nil {
            Text("\(blockedCount) blocked • \(enabledOptionsCount) options")
              .font(.caption2)
              .foregroundStyle(secondaryTextColor)
          } else {
            Text("Choose a profile in the widget settings.")
              .font(.caption2)
              .foregroundStyle(secondaryTextColor)
          }

          if !entry.isSessionActive && !isUnavailable {
            Link(destination: linkToOpen) {
              Text(quickLaunchEnabled ? "Launch profile" : "Open app")
                .font(.caption.weight(.semibold))
                .foregroundStyle(primaryTextColor)
            }
          }
        }
      }
      .padding(16)
      .overlay(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
          .stroke(
            Color.white.opacity(
              entry.isSessionActive || entry.isBreakActive || entry.isPauseActive
                ? 0.12 : 0.32
            ),
            lineWidth: 1
          )
      }
      .blur(radius: isUnavailable ? 2.5 : 0)

      if isUnavailable {
        unavailableOverlay
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
  }

  private var unavailableOverlay: some View {
    VStack(spacing: 8) {
      Image(systemName: "exclamationmark.triangle.fill")
        .font(.title3)
        .foregroundStyle(Color(red: 0.72, green: 0.45, blue: 0.18))

      Text("Unavailable")
        .font(.headline.weight(.semibold))
        .foregroundStyle(Color(red: 0.18, green: 0.17, blue: 0.16))

      Text("Another profile is active.")
        .font(.caption)
        .foregroundStyle(Color(red: 0.39, green: 0.37, blue: 0.34))
        .multilineTextAlignment(.center)
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(Color(red: 0.97, green: 0.94, blue: 0.9).opacity(0.95))
    )
    .padding(14)
  }

  private var statusCapsule: some View {
    HStack(spacing: 5) {
      Image(systemName: statusSymbol)
        .font(.caption2.weight(.semibold))
      Text(statusLabel)
        .font(.caption2.weight(.semibold))
    }
    .foregroundStyle(
      entry.isSessionActive || entry.isBreakActive || entry.isPauseActive
        ? accentColor
        : Color(red: 0.39, green: 0.37, blue: 0.34)
    )
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(
      Capsule(style: .continuous)
        .fill(Color.white.opacity(0.72))
    )
  }

  private var countdownRange: ClosedRange<Date>? {
    guard let activeSession = entry.activeSession?.toWidgetAttributesContentState() else {
      return nil
    }
    return activeSession.countdownRange
  }
}

#Preview(as: .systemSmall) {
  ProfileControlWidget()
} timeline: {
  ProfileWidgetEntry(
    date: .now,
    selectedProfileId: "test-id",
    profileName: "Focus Session",
    activeSession: nil,
    profileSnapshot: SharedData.ProfileSnapshot(
      id: UUID(),
      name: "Focus Session",
      selectedActivity: FamilyActivitySelection(),
      createdAt: Date(),
      updatedAt: Date(),
      blockingStrategyId: nil,
      order: 0,
      enableLiveActivity: true,
      reminderTimeInSeconds: nil,
      customReminderMessage: nil,
      enableBreaks: true,
      enableStrictMode: true,
      enableAllowMode: true,
      enableAllowModeDomains: true,
      enableSafariBlocking: true,
      domains: ["facebook.com", "twitter.com"],
      schedule: nil,
      disableBackgroundStops: nil
    ),
    deepLinkURL: URL(string: "https://foqos.app/profile/test-id"),
    focusMessage: "Stay focused and avoid distractions",
    useProfileURL: true
  )

  let activeProfileId = UUID()
  ProfileWidgetEntry(
    date: .now,
    selectedProfileId: activeProfileId.uuidString,
    profileName: "Deep Work Session",
    activeSession: SharedData.SessionSnapshot(
      id: "test-session",
      tag: "test-tag",
      blockedProfileId: activeProfileId,
      startTime: Date(timeIntervalSinceNow: -300),
      endTime: nil,
      breakStartTime: nil,
      breakEndTime: nil,
      forceStarted: true
    ),
    profileSnapshot: SharedData.ProfileSnapshot(
      id: activeProfileId,
      name: "Deep Work Session",
      selectedActivity: FamilyActivitySelection(),
      createdAt: Date(),
      updatedAt: Date(),
      blockingStrategyId: nil,
      order: 0,
      enableLiveActivity: true,
      reminderTimeInSeconds: nil,
      customReminderMessage: nil,
      enableBreaks: true,
      enableStrictMode: false,
      enableAllowMode: true,
      enableAllowModeDomains: true,
      enableSafariBlocking: true,
      domains: ["youtube.com", "reddit.com"],
      schedule: nil,
      disableBackgroundStops: nil
    ),
    deepLinkURL: URL(string: "https://foqos.app/profile/\(activeProfileId.uuidString)"),
    focusMessage: "Deep focus time",
    useProfileURL: true
  )
}

#Preview(as: .accessoryRectangular) {
  ProfileControlWidget()
} timeline: {
  let activeProfileId = UUID()
  ProfileWidgetEntry(
    date: .now,
    selectedProfileId: activeProfileId.uuidString,
    profileName: "Deep Work",
    activeSession: SharedData.SessionSnapshot(
      id: "rect-session",
      tag: "rect-tag",
      blockedProfileId: activeProfileId,
      startTime: Date(timeIntervalSinceNow: -300),
      endTime: nil,
      breakStartTime: nil,
      breakEndTime: nil,
      forceStarted: true
    ),
    profileSnapshot: SharedData.ProfileSnapshot(
      id: activeProfileId,
      name: "Deep Work",
      selectedActivity: FamilyActivitySelection(),
      createdAt: Date(),
      updatedAt: Date(),
      blockingStrategyId: nil,
      order: 0,
      enableLiveActivity: true,
      reminderTimeInSeconds: nil,
      customReminderMessage: nil,
      enableBreaks: true,
      enableStrictMode: true,
      enableAllowMode: false,
      enableAllowModeDomains: false,
      enableSafariBlocking: true,
      domains: ["youtube.com", "reddit.com", "twitter.com"],
      schedule: nil,
      disableBackgroundStops: nil
    ),
    deepLinkURL: URL(string: "https://foqos.app/profile/\(activeProfileId.uuidString)"),
    focusMessage: "Deep focus time",
    useProfileURL: true
  )
}

#Preview(as: .accessoryInline) {
  ProfileControlWidget()
} timeline: {
  let breakProfileId = UUID()
  ProfileWidgetEntry(
    date: .now,
    selectedProfileId: breakProfileId.uuidString,
    profileName: "Study Session",
    activeSession: SharedData.SessionSnapshot(
      id: "inline-break-session",
      tag: "inline-break-tag",
      blockedProfileId: breakProfileId,
      startTime: Date(timeIntervalSinceNow: -600),
      endTime: nil,
      breakStartTime: Date(timeIntervalSinceNow: -60),
      breakEndTime: nil,
      forceStarted: true
    ),
    profileSnapshot: SharedData.ProfileSnapshot(
      id: breakProfileId,
      name: "Study Session",
      selectedActivity: FamilyActivitySelection(),
      createdAt: Date(),
      updatedAt: Date(),
      blockingStrategyId: nil,
      order: 0,
      enableLiveActivity: true,
      reminderTimeInSeconds: nil,
      customReminderMessage: nil,
      enableBreaks: true,
      enableStrictMode: false,
      enableAllowMode: false,
      enableAllowModeDomains: false,
      enableSafariBlocking: true,
      domains: ["tiktok.com"],
      schedule: nil,
      disableBackgroundStops: nil
    ),
    deepLinkURL: URL(string: "https://foqos.app/profile/\(breakProfileId.uuidString)"),
    focusMessage: "Take a break",
    useProfileURL: true
  )
}
