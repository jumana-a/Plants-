import Foundation

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
