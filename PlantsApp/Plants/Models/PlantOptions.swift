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
