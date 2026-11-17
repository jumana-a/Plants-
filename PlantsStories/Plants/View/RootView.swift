import SwiftUI

// MARK: - RootView
// يقرر أي صفحة تنعرض، ويعطي الـ ViewModels لكل الصفحات

struct RootView: View {
    @State private var startViewModel = StartViewModel()
    @State private var listViewModel = PlantListViewModel()

    var body: some View {
        Group {
            if !startViewModel.hasSeenStart {
                StartView()
            } else {
                switch listViewModel.screen {
                case .empty:
                    NoRemindersView()
                case .today:
                    TodayView()
                case .allDone:
                    AllDoneView()
                }
            }
        }
        .sheet(item: $listViewModel.sheet) { item in
            SetReminderView(plant: item.plant)
                .presentationBackground(AppColor.sheet.color)
                .presentationCornerRadius(40)
                .presentationDragIndicator(.hidden)
        }
        .environment(startViewModel)
        .environment(listViewModel)
    }
}

#Preview("App") {
    let _ = UserDefaults.standard.removeObject(forKey: "hasSeenStartScreen")
    let _ = UserDefaults.standard.removeObject(forKey: "savedPlants")
    RootView()
}
