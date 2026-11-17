import SwiftUI

struct SetReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PlantListViewModel.self) private var listViewModel
    @State private var viewModel: SetReminderViewModel

    init(plant: Plant?) {
        _viewModel = State(initialValue: SetReminderViewModel(plant: plant))
    }

    var body: some View {
        VStack(spacing: 0) {

            ZStack {
                Text("Set Reminder")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary.color)

                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(AppColor.textPrimary.color)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)

                    Spacer()

                    Button {
                        if viewModel.save(in: listViewModel) {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.circle)
                    .tint(AppColor.buttonGreen.color)
                    .disabled(!viewModel.canSave)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 14)

            HStack(spacing: 8) {
                Text("Plant Name")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(AppColor.textPrimary.color)

                TextField(
                    "",
                    text: $viewModel.name,
                    prompt: Text("Pothos").foregroundStyle(AppColor.textGray.color)
                )
                .font(.system(size: 17))
                .foregroundStyle(AppColor.textPrimary.color)
                .tint(AppColor.brightGreen.color)
            }
            .padding(.horizontal, 19)
            .frame(height: 59)
            .background(AppColor.card.color, in: Capsule())
            .padding(.horizontal, 20)
            .padding(.top, 55)

            VStack(spacing: 0) {
                FormRow(icon: "location", title: "Room", selection: $viewModel.room)
                Divider().overlay(AppColor.line.color).padding(.horizontal, 16)
                FormRow(icon: "sun.max", title: "Light", selection: $viewModel.light)
            }
            .background(AppColor.card.color, in: RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 20)
            .padding(.top, 50)

            VStack(spacing: 0) {
                FormRow(icon: "drop", title: "Watering Days", selection: $viewModel.wateringDays)
                Divider().overlay(AppColor.line.color).padding(.horizontal, 16)
                FormRow(icon: "drop", title: "Water", selection: $viewModel.water)
            }
            .background(AppColor.card.color, in: RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 20)
            .padding(.top, 40)

            if viewModel.isEditing {
                Button {
                    viewModel.delete(in: listViewModel)
                    dismiss()
                } label: {
                    Text("Delete Reminder")
                        .font(.system(size: 17))
                        .foregroundStyle(AppColor.red.color)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColor.card.color, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.top, 50)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.sheet.color.ignoresSafeArea())
    }
}

// MARK: - سطر في الفورم (Room / Light / Water ...)

struct FormRow<Value: Hashable & CaseIterable & RawRepresentable>: View where Value.RawValue == String {
    let icon: String
    let title: String
    @Binding var selection: Value

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .frame(width: 22)

            Text(title)

            Spacer()

            Menu {
                Picker(title, selection: $selection) {
                    ForEach(Array(Value.allCases), id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selection.rawValue)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(AppColor.textGray.color)
            }
        }
        .font(.system(size: 17))
        .foregroundStyle(AppColor.textPrimary.color)
        .padding(.horizontal, 20)
        .frame(height: 47)
    }
}

// MARK: - Previews

#Preview("Set Reminder") {
    Color(AppColor.background.rawValue)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SetReminderView(plant: nil)
                .environment(PlantListViewModel(previewPlants: []))
                .presentationBackground(AppColor.sheet.color)
                .presentationCornerRadius(40)
                .presentationDragIndicator(.hidden)
        }
}

#Preview("Edit Reminder") {
    Color(AppColor.background.rawValue)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SetReminderView(plant: Plant(name: "Pothos", room: .bedroom, light: .fullSun, wateringDays: .everyDay, water: .ml20to50))
                .environment(PlantListViewModel(previewPlants: []))
                .presentationBackground(AppColor.sheet.color)
                .presentationCornerRadius(40)
                .presentationDragIndicator(.hidden)
        }
}
