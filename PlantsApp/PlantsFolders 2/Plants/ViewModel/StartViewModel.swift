import Foundation
import Observation

// MARK: - StartViewModel
// مسؤول فقط عن صفحة البداية: هل المستخدم شاف صفحة البداية قبل أو لا

@Observable
final class StartViewModel {
    private let startKey = "hasSeenStartScreen"
    private let plantsKey = "savedPlants"

    private(set) var hasSeenStart: Bool

    init() {
        let defaults = UserDefaults.standard
        // إذا ضغط "Set Plant Reminder" قبل، أو عنده نباتات محفوظة → لا نعرض صفحة البداية
        hasSeenStart = defaults.bool(forKey: startKey) || defaults.data(forKey: plantsKey) != nil
    }

    // للـ Preview فقط
    init(hasSeenStart: Bool) {
        self.hasSeenStart = hasSeenStart
    }

    func startJourney() {
        hasSeenStart = true
        UserDefaults.standard.set(true, forKey: startKey)
    }
}
