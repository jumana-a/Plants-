import SwiftUI

struct AddPlantButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(AppColors.buttonGreen)
        .padding(.trailing, 30)
        .padding(.bottom, 8)
    }
}
