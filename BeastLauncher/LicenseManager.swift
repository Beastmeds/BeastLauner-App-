import Foundation
import Combine

class LicenseManager: ObservableObject {
    @Published var isUnlocked: Bool = false
    @Published var errorMessage: String = ""

    private let validKeys: Set<String> = [
        "BEAST-1234-ACCESS",
        "DEV-9999-TEST",
        "NICO-2026-ULTRA"
    ]

    private let storageKey = "beast_license_key"

    init() {
        if let saved = UserDefaults.standard.string(forKey: storageKey),
           validKeys.contains(saved) {
            isUnlocked = true
        }
    }

    func validate(key: String) {
        let trimmed = key.trimmingCharacters(in: .whitespaces).uppercased()
        if validKeys.contains(trimmed) {
            UserDefaults.standard.set(trimmed, forKey: storageKey)
            isUnlocked = true
            errorMessage = ""
        } else {
            errorMessage = "Invalid License Key"
            LogSystem.shared.log("License attempt failed: \(trimmed)")
        }
    }

    func revoke() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        isUnlocked = false
    }
}
