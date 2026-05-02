import SwiftUI

// MARK: - Debug View
struct DebugView: View {
    @ObservedObject var log = LogSystem.shared

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "ladybug.fill")
                    .foregroundColor(.orange)
                Text("Debug Log")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Button(action: { log.clear() }) {
                    Image(systemName: "trash")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white.opacity(0.04))

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        if log.logs.isEmpty {
                            Text("No logs yet.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        ForEach(log.logs.indices, id: \.self) { i in
                            Text(log.logs[i])
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(Color(hex: "#00FF41"))
                                .id(i)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onChange(of: log.logs.count) { _ in
                    proxy.scrollTo(log.logs.count - 1, anchor: .bottom)
                }
            }
        }
        .background(Color.black)
        .padding(.bottom, 90)
    }
}

// MARK: - Dock Bar
struct DockBar: View {
    @Binding var currentPage: HomeView.Page
    @ObservedObject var theme: ThemeManager

    struct DockItem {
        let page: HomeView.Page
        let icon: String
        let label: String
    }

    let items: [DockItem] = [
        DockItem(page: .home,     icon: "house.fill",      label: "Home"),
        DockItem(page: .terminal, icon: "terminal",         label: "Terminal"),
        DockItem(page: .files,    icon: "folder.fill",      label: "Files"),
        DockItem(page: .widgets,  icon: "square.grid.2x2", label: "Widgets"),
        DockItem(page: .debug,    icon: "ladybug.fill",     label: "Debug"),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.label) { item in
                Button(action: { currentPage = item.page }) {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20))
                            .foregroundColor(currentPage == item.page ? theme.accent : .gray)
                        Text(item.label)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(currentPage == item.page ? theme.accent : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.3), radius: 10, y: -2)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Settings Sheet
struct SettingsSheet: View {
    @ObservedObject var theme: ThemeManager
    @ObservedObject var licenseManager: LicenseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                Form {
                    Section(header: Text("Appearance").foregroundColor(theme.textSecondary)) {
                        Toggle("Hacker Mode", isOn: $theme.hackerMode)
                            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#00FF41")))
                            .foregroundColor(theme.textPrimary)
                    }
                    Section(header: Text("License").foregroundColor(theme.textSecondary)) {
                        HStack {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(.green)
                            Text("License Active")
                                .foregroundColor(theme.textPrimary)
                        }
                        Button(role: .destructive, action: {
                            licenseManager.revoke()
                            dismiss()
                        }) {
                            Label("Revoke License", systemImage: "xmark.circle")
                        }
                    }
                    Section(header: Text("About").foregroundColor(theme.textSecondary)) {
                        HStack {
                            Text("Version").foregroundColor(theme.textPrimary)
                            Spacer()
                            Text("1.0.0").foregroundColor(theme.textSecondary)
                        }
                        HStack {
                            Text("Build").foregroundColor(theme.textPrimary)
                            Spacer()
                            Text("1").foregroundColor(theme.textSecondary)
                        }
                        HStack {
                            Text("Developer").foregroundColor(theme.textPrimary)
                            Spacer()
                            Text("beastmeds").foregroundColor(theme.textSecondary)
                        }
                    }
                }
                
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundColor(theme.accent)
                }
            }
        }
    }
}

// MARK: - Corner Radius Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
