import SwiftUI

struct ReminderRow<Value: Hashable & CaseIterable & RawRepresentable>: View where Value.RawValue == String {
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
                .foregroundStyle(AppColors.valueGray)
            }
        }
        .font(.system(size: 17))
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .frame(height: 47)
    }
}
