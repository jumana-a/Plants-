import SwiftUI

enum RowState {
    case pending
    case done

    var contentOpacity: Double {
        switch self {
        case .pending: return 1
        case .done: return 0.5
        }
    }
}

struct TodayRow: View {
    let plant: Plant
    let onToggle: () -> Void

    private var state: RowState {
        plant.isWateredToday ? .done : .pending
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 24) {
                Button(action: onToggle) {
                    ZStack {
                        if state == .done {
                            Circle()
                                .fill(AppColors.doneGreen)
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.black.opacity(0.75))
                        } else {
                            Circle()
                                .strokeBorder(Color.white.opacity(0.7), lineWidth: 1.5)
                        }
                    }
                    .frame(width: 24, height: 24)
                    .contentShape(Circle())
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 2) {
                    Label("in \(plant.room.rawValue)", systemImage: "location")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white.opacity(0.5))

                    Text(plant.name)
                        .font(.system(size: 28))
                        .foregroundStyle(.white)

                    HStack(spacing: 14) {
                        ForEach(InfoChipKind.allCases, id: \.self) { kind in
                            InfoChip(kind: kind, plant: plant)
                        }
                    }
                    .padding(.top, 6)
                }
                .opacity(state.contentOpacity)

                Spacer()
            }
            .padding(.leading, 15)
            .padding(.vertical, 10)

            Rectangle()
                .fill(AppColors.rowDivider)
                .frame(height: 1)
                .padding(.leading, 9)
        }
    }
}
