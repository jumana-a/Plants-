import SwiftUI

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
