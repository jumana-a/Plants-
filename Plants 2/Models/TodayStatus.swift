import Foundation

enum TodayStatus {
    case noneDue
    case waiting
    case progress(done: Int)
    case allDone

    var message: String {
        switch self {
        case .noneDue:
            return "No plants need water today ☀️"
        case .waiting:
            return "Your plants are waiting for a sip 💦"
        case .progress(let done):
            return "\(done) of your plants feel loved today ✨"
        case .allDone:
            return "All reminders completed 🎉"
        }
    }
}
