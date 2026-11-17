import SwiftUI

struct StartView: View {
    @Environment(StartViewModel.self) private var viewModel

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
                    .foregroundStyle(AppColor.textGray.color)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity)

            Spacer()

            Button {
                viewModel.startJourney()
            } label: {
                Text("Set Plant Reminder")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 280, height: 24)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .tint(AppColor.buttonGreen.color)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background.color.ignoresSafeArea())
    }
}

#Preview("Start") {
    StartView()
        .environment(StartViewModel(hasSeenStart: false))
}
