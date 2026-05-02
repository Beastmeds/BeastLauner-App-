import SwiftUI

@main
struct BeastLauncherApp: App {
    @StateObject private var licenseManager = LicenseManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(licenseManager)
                .preferredColorScheme(.dark)
        }
    }
}
