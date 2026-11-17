import SwiftUI

@Observable
final class PlantsViewModel {
    private let storage: PlantStorage

    private(set) var plants: [Plant]

    init(storage: PlantStorage = PlantStorage()) {
        self.storage = storage
        self.plants = storage.load()
    }

    init(previewPlants: [Plant]) {
        self.storage = PlantStorage()
        self.plants = previewPlants
    }

    var hasPlants: Bool {
        !plants.isEmpty
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

    func add(_ plant: Plant) {
        plants.append(plant)
        storage.save(plants)
    }

    func toggleWatered(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].lastWatered = plant.isWateredToday ? nil : Date()
        storage.save(plants)
    }
}
