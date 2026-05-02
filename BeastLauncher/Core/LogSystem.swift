import Foundation

class LogSystem: ObservableObject {
    static let shared = LogSystem()
    @Published var logs: [String] = []

    func log(_ message: String) {
        let ts = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let entry = "[\(ts)] \(message)"
        logs.append(entry)
        print("[BeastLog] \(entry)")
    }

    func clear() {
        logs.removeAll()
    }
}
