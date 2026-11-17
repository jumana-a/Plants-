import Foundation
import Observation

// MARK: - SetReminderViewModel
// مسؤول عن الفورم داخل الشيت: يحفظ اللي يكتبه المستخدم قبل ما نضغط ✓

@Observable
final class SetReminderViewModel {
    let plant: Plant?

    var name: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var water: WaterAmount

    init(plant: Plant?) {
        self.plant = plant
        name = plant?.name ?? ""
        room = plant?.room ?? .bedroom
        light = plant?.light ?? .fullSun
        wateringDays = plant?.wateringDays ?? .everyDay
        water = plant?.water ?? .ml20to50
    }

    // هل نحن نعدّل نبتة موجودة؟ (عشان نعرض زر الحذف)
    var isEditing: Bool {
        plant != nil
    }

    // ما نسمح بالحفظ إذا الاسم فاضي
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func save(in listViewModel: PlantListViewModel) -> Bool {
        listViewModel.save(
            id: plant?.id,
            name: name,
            room: room,
            light: light,
            wateringDays: wateringDays,
            water: water
        )
    }

    func delete(in listViewModel: PlantListViewModel) {
        guard let plant else { return }
        listViewModel.delete(plant)
    }
}
