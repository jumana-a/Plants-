import SwiftUI

// MARK: - ألوان التطبيق (من Assets)

enum AppColor: String {
    case background = "Background"
    case sheet = "Sheet"
    case card = "Card"
    case line = "Line"
    case chip = "Chip"
    case buttonGreen = "ButtonGreen"
    case brightGreen = "BrightGreen"
    case checkMark = "CheckMark"
    case textGray = "TextGray"
    case yellow = "Yellow"
    case blue = "Blue"
    case red = "Red"
    case textPrimary = "TextPrimary"

    var color: Color {
        Color(rawValue)
    }
}

// MARK: - العنوان اللي فوق (مستخدم في أكثر من صفحة)

struct PlantsHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(AppColor.textPrimary.color)
                .padding(.horizontal, 24)
                .padding(.top, 16)

            Divider()
                .overlay(AppColor.line.color)
                .padding(.top, 12)
        }
    }
}
