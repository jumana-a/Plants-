import Foundation

enum Room: String, CaseIterable, Codable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case balcony = "Balcony"
}

enum Light: String, CaseIterable, Codable {
    case fullSun = "Full sun"
    case partialSun = "Partial sun"
    case shade = "Shade"
}

enum WateringDays: String, CaseIterable, Codable {
    case everyDay = "Every day"
    case every2Days = "Every 2 days"
    case every3Days = "Every 3 days"
    case onceAWeek = "Once a week"
    case every2Weeks = "Every 2 weeks"

    var intervalDays: Int {
        switch self {
        case .everyDay: return 1
        case .every2Days: return 2
        case .every3Days: return 3
        case .onceAWeek: return 7
        case .every2Weeks: return 14
        }
    }
}

enum WaterAmount: String, CaseIterable, Codable {
    case ml20to50 = "20-50 ml"
    case ml50to100 = "50-100 ml"
    case ml100to200 = "100-200 ml"
    case ml200to300 = "200-300 ml"
}

enum TodayStatus {
    case noneDue
    case waiting
    case progress(done: Int)
    case allDone

    var message: String {
        switch self {
        case .noneDue:
            return "No plants need water today ☀️"
        case .waiting:
            return "Your plants are waiting for a sip 💦"
        case .progress(let done):
            return "\(done) of your plants feel loved today ✨"
        case .allDone:
            return "All reminders completed 🎉"
        }
    }
}

struct Plant: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var water: WaterAmount
    var lastWatered: Date?

    var isWateredToday: Bool {
        guard let lastWatered else { return false }
        return Calendar.current.isDateInToday(lastWatered)
    }

    var isDueToday: Bool {
        guard let lastWatered else { return true }
        if isWateredToday { return true }

        let calendar = Calendar.current
        let days = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: lastWatered),
            to: calendar.startOfDay(for: Date())
        ).day ?? 0
        return days >= wateringDays.intervalDays
    }
}
