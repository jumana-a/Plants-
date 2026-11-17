import SwiftUI

@Observable
final class PlantViewModel {
    private let saveKey = "savedPlants"

    private(set) var plants: [Plant] = []

    init() {
        load()
    }

    init(previewPlants: [Plant]) {
        plants = previewPlants
    }

    var todayPlants: [Plant] {
        let due = plants.filter { $0.isDueToday }
        return due.filter { !$0.isWateredToday } + due.filter { $0.isWateredToday }
    }

    var doneCount: Int {
        todayPlants.filter { $0.isWateredToday }.count
    }

    var progress: Double {
        let total = todayPlants.count
        if total == 0 { return 0 }
        return Double(doneCount) / Double(total)
    }

    var todayStatus: TodayStatus {
        if todayPlants.isEmpty { return .noneDue }
        if doneCount == 0 { return .waiting }
        if doneCount == todayPlants.count { return .allDone }
        return .progress(done: doneCount)
    }

    func addPlant(name: String, room: Room, light: Light, wateringDays: WateringDays, water: WaterAmount) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }

        let plant = Plant(
            name: trimmedName,
            room: room,
            light: light,
            wateringDays: wateringDays,
            water: water
        )
        plants.append(plant)
        save()
        return true
    }

    func toggleWatered(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].lastWatered = plant.isWateredToday ? nil : Date()
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode([Plant].self, from: data) else {
            return
        }
        plants = saved
    }
}
