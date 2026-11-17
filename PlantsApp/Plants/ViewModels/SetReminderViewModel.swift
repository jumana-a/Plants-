import SwiftUI

@Observable
final class SetReminderViewModel {
    var plantName = ""
    var room: Room = .bedroom
    var light: Light = .fullSun
    var wateringDays: WateringDays = .everyDay
    var water: WaterAmount = .ml20to50
    var showNameError = false

    var trimmedName: String {
        plantName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func makePlant() -> Plant? {
        guard !trimmedName.isEmpty else {
            showNameError = true
            return nil
        }

        return Plant(
            name: trimmedName,
            room: room,
            light: light,
            wateringDays: wateringDays,
            water: water
        )
    }

    func nameChanged() {
        showNameError = false
    }
}
