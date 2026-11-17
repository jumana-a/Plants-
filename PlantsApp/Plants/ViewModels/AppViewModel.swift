import SwiftUI

enum AppScreen {
    case start
    case noReminders
    case today
}

@Observable
final class AppViewModel {
    private static let seenKey = "hasSeenStartScreen"

    private(set) var hasSeenStartScreen: Bool
    var showSetReminder = false

    init() {
        hasSeenStartScreen = UserDefaults.standard.bool(forKey: AppViewModel.seenKey)
    }

    func currentScreen(hasPlants: Bool) -> AppScreen {
        if !hasSeenStartScreen { return .start }
        return hasPlants ? .today : .noReminders
    }

    func openSetReminder() {
        showSetReminder = true
    }

    func markStartScreenSeen() {
        hasSeenStartScreen = true
        UserDefaults.standard.set(true, forKey: AppViewModel.seenKey)
    }
}
