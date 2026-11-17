import Foundation
import Observation
import UserNotifications

// MARK: - أي صفحة نعرض بعد صفحة البداية
enum PlantListScreen {
    case empty
    case today
    case allDone
}

// MARK: - نوع الشيت (إضافة أو تعديل)
enum SheetType: Identifiable {
    case add
    case edit(Plant)

    var id: String {
        switch self {
        case .add: return "add"
        case .edit(let plant): return plant.id.uuidString
        }
    }

    var plant: Plant? {
        switch self {
        case .add: return nil
        case .edit(let plant): return plant
        }
    }
}

// MARK: - PlantListViewModel
// مسؤول عن قائمة النباتات: الحفظ، الحذف، السقي، التقدم، والإشعارات

@Observable
final class PlantListViewModel {
    private let plantsKey = "savedPlants"

    private(set) var plants: [Plant] = []
    var sheet: SheetType?

    init() {
        loadFromPhone()
    }

    // للـ Preview فقط
    init(previewPlants: [Plant]) {
        plants = previewPlants
    }

    // MARK: - بيانات للعرض

    var screen: PlantListScreen {
        if plants.isEmpty { return .empty }
        if case .allDone = todayStatus { return .allDone }
        return .today
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

    // MARK: - فتح الشيت

    func showAddSheet() {
        sheet = .add
    }

    func showEditSheet(for plant: Plant) {
        sheet = .edit(plant)
    }

    // MARK: - العمليات على النباتات

    func save(id: UUID?, name: String, room: Room, light: Light, wateringDays: WateringDays, water: WaterAmount) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }

        if let id, let index = plants.firstIndex(where: { $0.id == id }) {
            plants[index].name = trimmedName
            plants[index].room = room
            plants[index].light = light
            plants[index].wateringDays = wateringDays
            plants[index].water = water
        } else {
            let plant = Plant(
                name: trimmedName,
                room: room,
                light: light,
                wateringDays: wateringDays,
                water: water
            )
            plants.append(plant)
        }

        saveToPhone()
        return true
    }

    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        saveToPhone()
    }

    func toggleWatered(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].lastWatered = plant.isWateredToday ? nil : Date()
        saveToPhone()
    }

    // MARK: - الحفظ في الجوال

    private func saveToPhone() {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: plantsKey)
        }
        updateWaterReminder()
    }

    private func loadFromPhone() {
        guard let data = UserDefaults.standard.data(forKey: plantsKey),
              let saved = try? JSONDecoder().decode([Plant].self, from: data) else {
            return
        }
        plants = saved
    }

    // MARK: - الإشعار اليومي

    private func updateWaterReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyWater"])

        guard !plants.isEmpty else { return }

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = "My Plants 🌱"
            content.body = "Hey! let's water your plants"
            content.sound = .default

            var time = DateComponents()
            time.hour = 9

            let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
            center.add(UNNotificationRequest(identifier: "dailyWater", content: content, trigger: trigger))
        }
    }
}
