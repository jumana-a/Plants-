import Foundation

struct PlantStorage {
    private let key = "savedPlants"

    func load() -> [Plant] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let plants = try? JSONDecoder().decode([Plant].self, from: data) else {
            return []
        }
        return plants
    }

    func save(_ plants: [Plant]) {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
