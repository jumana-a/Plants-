import SwiftUI

struct NoRemindersView: View {
    let onAdd: () -> Void

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
                .foregroundStyle(AppColors.messageGray)
        }
        .overlay(alignment: .bottomTrailing) {
            AddPlantButton(action: onAdd)
        }
    }
}

#Preview {
    NoRemindersView(onAdd: {})
}
