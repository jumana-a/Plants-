import SwiftUI

enum InfoChipKind: CaseIterable {
    case light
    case water

    var icon: String {
        switch self {
        case .light: return "sun.max"
        case .water: return "drop"
        }
    }

    var color: Color {
        switch self {
        case .light: return AppColors.sunYellow
        case .water: return AppColors.waterBlue
        }
    }

    func text(for plant: Plant) -> String {
        switch self {
        case .light: return plant.light.rawValue
        case .water: return plant.water.rawValue
        }
    }
}

struct InfoChip: View {
    let kind: InfoChipKind
    let plant: Plant

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: kind.icon)
            Text(kind.text(for: plant))
        }
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(kind.color)
        .padding(.horizontal, 9)
        .frame(height: 23)
        .background(AppColors.chip, in: RoundedRectangle(cornerRadius: 8))
    }
}
