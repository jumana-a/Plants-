import SwiftUI

struct SetReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PlantsViewModel.self) private var plantsViewModel

    @State private var viewModel = SetReminderViewModel()
    @FocusState private var nameFocused: Bool

    private func save() {
        if let plant = viewModel.makePlant() {
            plantsViewModel.add(plant)
            dismiss()
        } else {
            nameFocused = true
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            ZStack {
                Text("Set Reminder")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)

                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)

                    Spacer()

                    Button(action: save) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.circle)
                    .tint(AppColors.buttonGreen)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 14)

            HStack(spacing: 8) {
                Text("Plant Name")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)

                TextField(
                    "",
                    text: $viewModel.plantName,
                    prompt: Text(viewModel.showNameError ? "Please enter a name" : "Pothos")
                        .foregroundStyle(viewModel.showNameError ? Color.red.opacity(0.8) : Color(white: 0.4))
                )
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .tint(AppColors.cursorGreen)
                .focused($nameFocused)
                .onChange(of: viewModel.plantName) {
                    viewModel.nameChanged()
                }
            }
            .padding(.horizontal, 19)
            .frame(height: 59)
            .background(AppColors.card, in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(Color.red.opacity(0.8), lineWidth: viewModel.showNameError ? 1.5 : 0)
            )
            .padding(.horizontal, 20)
            .padding(.top, 55)

            VStack(spacing: 0) {
                ReminderRow(icon: "location", title: "Room", selection: $viewModel.room)
                Divider().overlay(AppColors.cardDivider).padding(.horizontal, 16)
                ReminderRow(icon: "sun.max", title: "Light", selection: $viewModel.light)
            }
            .background(AppColors.card, in: RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 20)
            .padding(.top, 50)

            VStack(spacing: 0) {
                ReminderRow(icon: "drop", title: "Watering Days", selection: $viewModel.wateringDays)
                Divider().overlay(AppColors.cardDivider).padding(.horizontal, 16)
                ReminderRow(icon: "drop", title: "Water", selection: $viewModel.water)
            }
            .background(AppColors.card, in: RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 20)
            .padding(.top, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.sheetBackground.ignoresSafeArea())
    }
}

#Preview {
    SetReminderView()
        .environment(PlantsViewModel(previewPlants: []))
}
