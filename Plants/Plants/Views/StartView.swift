import SwiftUI

struct StartView: View {
    let onStart: () -> Void

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
                    .foregroundStyle(AppColors.subtitleGray)
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
            .tint(AppColors.buttonGreen)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    StartView(onStart: {})
}
