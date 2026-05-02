import SwiftUI

struct RootView: View {
    @EnvironmentObject var licenseManager: LicenseManager

    var body: some View {
        if licenseManager.isUnlocked {
            HomeView()
        } else {
            LicenseView()
        }
    }
}
