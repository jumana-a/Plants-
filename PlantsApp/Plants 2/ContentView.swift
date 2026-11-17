import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenStartScreen") private var hasSeenStartScreen = false
    @State private var viewModel = PlantViewModel()
    @State private var showSetReminder = false

    var body: some View {
        Group {
            if !hasSeenStartScreen {
                StartView(onStart: { showSetReminder = true })
            } else if viewModel.plants.isEmpty {
                NoRemindersView(onAdd: { showSetReminder = true })
            } else {
                TodayView(onAdd: { showSetReminder = true })
            }
        }
        .sheet(isPresented: $showSetReminder, onDismiss: {
            if !viewModel.plants.isEmpty {
                hasSeenStartScreen = true
            }
        }) {
            SetReminderView()
                .presentationBackground(Color(red: 0.11, green: 0.11, blue: 0.118))
                .presentationCornerRadius(40)
                .presentationDragIndicator(.hidden)
        }
        .environment(viewModel)
    }
}

struct PlantsHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.top, 16)

            Divider()
                .overlay(Color.white.opacity(0.2))
                .padding(.top, 12)
        }
    }
}

struct AddPlantButton: View {
    let action: () -> Void

    private let buttonGreen = Color(red: 0.17, green: 0.48, blue: 0.37)

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(buttonGreen)
        .padding(.trailing, 30)
        .padding(.bottom, 8)
    }
}

struct StartView: View {
    let onStart: () -> Void

    private let subtitleGray = Color(red: 0.62, green: 0.62, blue: 0.57)
    private let buttonGreen = Color(red: 0.17, green: 0.48, blue: 0.37)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            PlantsHeader()

            Spacer()

            VStack(spacing: 16) {
                Image("plantPot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164, height: 200)

                Text("Start your plant journey!")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)

                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.system(size: 16))
                    .foregroundStyle(subtitleGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity)

            Spacer()

            Button(action: onStart) {
                Text("Set Plant Reminder")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 280, height: 42)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .tint(buttonGreen)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct NoRemindersView: View {
    let onAdd: () -> Void

    private let messageGray = Color(red: 0.46, green: 0.44, blue: 0.44)

    var body: some View {
        VStack(spacing: 0) {
            PlantsHeader()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black.ignoresSafeArea())
        .overlay {
            Text("No reminders set yet..")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(messageGray)
        }
        .overlay(alignment: .bottomTrailing) {
            AddPlantButton(action: onAdd)
        }
    }
}

struct TodayStyle {
    static let track = Color(red: 0.17, green: 0.17, blue: 0.18)
    static let progress = Color(red: 0.31, green: 0.66, blue: 0.55)
    static let done = Color(red: 0.18, green: 0.85, blue: 0.65)
    static let sun = Color(red: 0.8, green: 0.78, blue: 0.52)
    static let water = Color(red: 0.78, green: 0.85, blue: 0.93)
    static let divider = Color(red: 0.133, green: 0.133, blue: 0.141)
    static let chip = Color(red: 0.094, green: 0.094, blue: 0.114)
}

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
        case .light: return TodayStyle.sun
        case .water: return TodayStyle.water
        }
    }

    func text(for plant: Plant) -> String {
        switch self {
        case .light: return plant.light.rawValue
        case .water: return plant.water.rawValue
        }
    }
}

struct TodayView: View {
    @Environment(PlantViewModel.self) private var viewModel
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
                        .fill(TodayStyle.track)

                    Capsule()
                        .fill(TodayStyle.progress)
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
                                .fill(TodayStyle.done)
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
                .fill(TodayStyle.divider)
                .frame(height: 1)
                .padding(.leading, 9)
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
        .background(TodayStyle.chip, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct SetReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PlantViewModel.self) private var viewModel
    @FocusState private var nameFocused: Bool

    @State private var plantName = ""
    @State private var showNameError = false
    @State private var room: Room = .bedroom
    @State private var light: Light = .fullSun
    @State private var wateringDays: WateringDays = .everyDay
    @State private var water: WaterAmount = .ml20to50

    private let cardColor = Color(red: 0.173, green: 0.173, blue: 0.18)
    private let dividerColor = Color(red: 0.255, green: 0.255, blue: 0.267)
    private let cursorGreen = Color(red: 0.16, green: 0.875, blue: 0.66)
    private let buttonGreen = Color(red: 0.17, green: 0.48, blue: 0.37)

    private func save() {
        let saved = viewModel.addPlant(
            name: plantName,
            room: room,
            light: light,
            wateringDays: wateringDays,
            water: water
        )

        if saved {
            dismiss()
        } else {
            showNameError = true
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
                    .tint(buttonGreen)
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
                    text: $plantName,
                    prompt: Text(showNameError ? "Please enter a name" : "Pothos")
                        .foregroundStyle(showNameError ? Color.red.opacity(0.8) : Color(white: 0.4))
                )
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .tint(cursorGreen)
                .focused($nameFocused)
                .onChange(of: plantName) {
                    showNameError = false
                }
            }
            .padding(.horizontal, 19)
            .frame(height: 59)
            .background(cardColor, in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(Color.red.opacity(0.8), lineWidth: showNameError ? 1.5 : 0)
            )
            .padding(.horizontal, 20)
            .padding(.top, 55)

            VStack(spacing: 0) {
                ReminderRow(icon: "location", title: "Room", selection: $room)
                Divider().overlay(dividerColor).padding(.horizontal, 16)
                ReminderRow(icon: "sun.max", title: "Light", selection: $light)
            }
            .background(cardColor, in: RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 20)
            .padding(.top, 50)

            VStack(spacing: 0) {
                ReminderRow(icon: "drop", title: "Watering Days", selection: $wateringDays)
                Divider().overlay(dividerColor).padding(.horizontal, 16)
                ReminderRow(icon: "drop", title: "Water", selection: $water)
            }
            .background(cardColor, in: RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 20)
            .padding(.top, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.11, green: 0.11, blue: 0.118).ignoresSafeArea())
    }
}

struct ReminderRow<Value: Hashable & CaseIterable & RawRepresentable>: View where Value.RawValue == String {
    let icon: String
    let title: String
    @Binding var selection: Value

    private let valueGray = Color(red: 0.557, green: 0.557, blue: 0.576)

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
                .foregroundStyle(valueGray)
            }
        }
        .font(.system(size: 17))
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .frame(height: 47)
    }
}

#Preview("Start") {
    StartView(onStart: {})
}

#Preview("No reminders") {
    NoRemindersView(onAdd: {})
}

#Preview("Today") {
    TodayView(onAdd: {})
        .environment(PlantViewModel(previewPlants: [
            Plant(name: "Monstera", room: .kitchen, light: .fullSun, wateringDays: .everyDay, water: .ml20to50),
            Plant(name: "Pothos", room: .bedroom, light: .fullSun, wateringDays: .everyDay, water: .ml20to50),
            Plant(name: "Orchid", room: .livingRoom, light: .fullSun, wateringDays: .everyDay, water: .ml20to50, lastWatered: Date()),
            Plant(name: "Spider", room: .kitchen, light: .fullSun, wateringDays: .everyDay, water: .ml20to50, lastWatered: Date())
        ]))
}

#Preview("Set Reminder") {
    SetReminderView()
        .environment(PlantViewModel(previewPlants: []))
}
