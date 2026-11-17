import SwiftUI

// MARK: - لا يوجد نباتات

struct NoRemindersView: View {
    var body: some View {
        VStack(spacing: 0) {
            PlantsHeader()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AppColor.background.color.ignoresSafeArea())
        .overlay {
            Text("No reminders set yet..")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(AppColor.textGray.color)
        }
        .overlay(alignment: .bottomTrailing) {
            AddButton()
        }
    }
}

// MARK: - قائمة اليوم

struct TodayView: View {
    @Environment(PlantListViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 0) {
            PlantsHeader()

            Text(viewModel.todayStatus.message)
                .font(.system(size: 17))
                .foregroundStyle(AppColor.textPrimary.color)
                .padding(.top, 39)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColor.card.color)

                    Capsule()
                        .fill(AppColor.checkMark.color)
                        .frame(width: geo.size.width * viewModel.progress)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, 26)
            .padding(.top, 15)

            List(viewModel.todayPlants) { plant in
                PlantRow(plant: plant)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(AppColor.line.color)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(plant)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .contentMargins(.bottom, 90, for: .scrollContent)
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AppColor.background.color.ignoresSafeArea())
        .overlay(alignment: .bottomTrailing) {
            AddButton()
        }
    }
}

// MARK: - خلّص كل السقي

struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 0) {
            PlantsHeader()

            Spacer()

            ZStack {
                Circle()
                    .fill(AppColor.chip.color)
                    .frame(width: 220, height: 220)

                Image("PlantPot2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164, height: 200)
            }

            Text("All Done! 🎉")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(AppColor.textPrimary.color)
                .padding(.top, 24)

            Text("All Reminders Completed")
                .font(.system(size: 16))
                .foregroundStyle(AppColor.textGray.color)
                .padding(.top, 8)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AppColor.background.color.ignoresSafeArea())
        .overlay(alignment: .bottomTrailing) {
            AddButton()
        }
    }
}

// MARK: - مكونات خاصة بالقائمة

struct AddButton: View {
    @Environment(PlantListViewModel.self) private var viewModel

    var body: some View {
        Button {
            viewModel.showAddSheet()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(AppColor.buttonGreen.color)
        .padding(.trailing, 30)
        .padding(.bottom, 8)
    }
}

struct PlantRow: View {
    @Environment(PlantListViewModel.self) private var viewModel
    let plant: Plant

    var body: some View {
        HStack(spacing: 24) {
            Button {
                withAnimation(.easeInOut) {
                    viewModel.toggleWatered(plant)
                }
            } label: {
                ZStack {
                    if plant.isWateredToday {
                        Circle()
                            .fill(AppColor.brightGreen.color)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.black.opacity(0.75))
                    } else {
                        Circle()
                            .strokeBorder(AppColor.textPrimary.color.opacity(0.7), lineWidth: 1.5)
                    }
                }
                .frame(width: 24, height: 24)
                .contentShape(Circle())
            }
            .buttonStyle(.borderless)

            VStack(alignment: .leading, spacing: 2) {
                Label("in \(plant.room.rawValue)", systemImage: "location")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.textPrimary.color.opacity(0.5))

                Text(plant.name)
                    .font(.system(size: 28))
                    .foregroundStyle(AppColor.textPrimary.color)

                HStack(spacing: 14) {
                    Chip(icon: "sun.max", text: plant.light.rawValue, color: AppColor.yellow.color)
                    Chip(icon: "drop", text: plant.water.rawValue, color: AppColor.blue.color)
                }
                .padding(.top, 6)
            }
            .opacity(plant.isWateredToday ? 0.5 : 1)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.showEditSheet(for: plant)
            }

            Spacer()
        }
        .padding(.leading, 15)
        .padding(.vertical, 10)
    }
}

struct Chip: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(color)
        .padding(.horizontal, 9)
        .frame(height: 23)
        .background(AppColor.chip.color, in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Previews

#Preview("Today") {
    TodayView()
        .environment(PlantListViewModel(previewPlants: [
            Plant(name: "Monstera", room: .kitchen, light: .fullSun, wateringDays: .everyDay, water: .ml20to50),
            Plant(name: "Pothos", room: .bedroom, light: .fullSun, wateringDays: .everyDay, water: .ml20to50),
            Plant(name: "Orchid", room: .livingRoom, light: .fullSun, wateringDays: .everyDay, water: .ml20to50, lastWatered: Date())
        ]))
}

#Preview("Empty") {
    NoRemindersView()
        .environment(PlantListViewModel(previewPlants: []))
}

#Preview("All Done") {
    AllDoneView()
        .environment(PlantListViewModel(previewPlants: []))
}
