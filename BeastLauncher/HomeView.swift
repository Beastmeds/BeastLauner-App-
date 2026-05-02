import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @StateObject private var theme = ThemeManager()
    @EnvironmentObject var licenseManager: LicenseManager
    @State private var currentPage: Page = .home
    @State private var showSettings = false

    enum Page { case home, terminal, files, widgets, debug }

    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()

            switch currentPage {
            case .home:
                homeContent
            case .terminal:
                TerminalView(theme: theme)
            case .files:
                FileManagerView(theme: theme)
            case .widgets:
                WidgetView(theme: theme)
            case .debug:
                DebugView()
            }

            // Bottom dock
            VStack {
                Spacer()
                DockBar(currentPage: $currentPage, theme: theme)
            }
        }
        .environmentObject(theme)
        .sheet(isPresented: $showSettings) {
            SettingsSheet(theme: theme, licenseManager: licenseManager)
        }
    }

    var homeContent: some View {
        VStack(spacing: 0) {
            // Status bar area
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("BeastLauncher")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(theme.textPrimary)
                    Text(Date(), style: .date)
                        .font(.system(size: 13))
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
                HStack(spacing: 12) {
                    Button(action: { vm.showHidden.toggle() }) {
                        Image(systemName: vm.showHidden ? "eye.slash" : "eye")
                            .foregroundColor(theme.textSecondary)
                    }
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(theme.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            ScrollView {
                AppGridView(vm: vm, theme: theme, currentPage: $currentPage)
                    .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $vm.showAddSheet) {
            AddFakeAppSheet(vm: vm, theme: theme)
        }
    }
}
