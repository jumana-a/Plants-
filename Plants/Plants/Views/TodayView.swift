import SwiftUI

struct TodayView: View {
    @Environment(PlantsViewModel.self) private var viewModel
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            PlantsHeader()

            Text(viewModel.todayStatus.message)
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding(.top, 39)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.progressTrack)

                    Capsule()
                        .fill(AppColors.progressFill)
                        .frame(width: geo.size.width * viewModel.progress)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, 26)
            .padding(.top, 15)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.todayPlants) { plant in
                        TodayRow(plant: plant) {
                            withAnimation(.easeInOut) {
                                viewModel.toggleWatered(plant)
                            }
                        }
                    }
                }
                .padding(.bottom, 90)
            }
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black.ignoresSafeArea())
        .overlay(alignment: .bottomTrailing) {
            AddPlantButton(action: onAdd)
        }
    }
}

#Preview {
    TodayView(onAdd: {})
        .environment(PlantsViewModel(previewPlants: [
            Plant(name: "Monstera", room: .kitchen, light: .fullSun, wateringDays: .everyDay, water: .ml20to50),
            Plant(name: "Pothos", room: .bedroom, light: .fullSun, wateringDays: .everyDay, water: .ml20to50),
            Plant(name: "Orchid", room: .livingRoom, light: .fullSun, wateringDays: .everyDay, water: .ml20to50, lastWatered: Date()),
            Plant(name: "Spider", room: .kitchen, light: .fullSun, wateringDays: .everyDay, water: .ml20to50, lastWatered: Date())
        ]))
}
