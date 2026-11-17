import SwiftUI

struct RootView: View {
    @State private var appViewModel = AppViewModel()
    @State private var plantsViewModel = PlantsViewModel()

    var body: some View {
        Group {
            switch appViewModel.currentScreen(hasPlants: plantsViewModel.hasPlants) {
            case .start:
                StartView(onStart: { appViewModel.openSetReminder() })
            case .noReminders:
                NoRemindersView(onAdd: { appViewModel.openSetReminder() })
            case .today:
                TodayView(onAdd: { appViewModel.openSetReminder() })
            }
        }
        .sheet(isPresented: $appViewModel.showSetReminder, onDismiss: {
            if plantsViewModel.hasPlants {
                appViewModel.markStartScreenSeen()
            }
        }) {
            SetReminderView()
                .presentationBackground(AppColors.sheetBackground)
                .presentationCornerRadius(40)
                .presentationDragIndicator(.hidden)
        }
        .environment(plantsViewModel)
    }
}
