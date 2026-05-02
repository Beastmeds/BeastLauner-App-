import SwiftUI

struct AppGridView: View {
    @ObservedObject var vm: HomeViewModel
    @ObservedObject var theme: ThemeManager
    @Binding var currentPage: HomeView.Page
    @State private var selectedFake: AppModel? = nil

    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(vm.visibleApps) { app in
                AppIconView(app: app, theme: theme)
                    .contextMenu {
                        Button(action: { vm.toggleHidden(app) }) {
                            Label(app.isHidden ? "Show" : "Hide", systemImage: app.isHidden ? "eye" : "eye.slash")
                        }
                        if app.isFake {
                            Button(role: .destructive, action: { vm.deleteApp(app) }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onTapGesture {
                        handleTap(app: app)
                    }
            }

            // Add fake app button
            Button(action: { vm.showAddSheet = true }) {
                VStack(spacing: 6) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 60, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                        Image(systemName: "plus")
                            .font(.system(size: 22))
                            .foregroundColor(theme.accent)
                    }
                    Text("Add")
                        .font(.system(size: 11))
                        .foregroundColor(theme.textSecondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .sheet(item: $selectedFake) { app in
            FakeAppScreen(app: app, theme: theme)
        }
    }

    private func handleTap(app: AppModel) {
        switch app.name {
        case "Terminal": currentPage = .terminal
        case "Files": currentPage = .files
        case "Widgets": currentPage = .widgets
        case "Clock": currentPage = .widgets
        default:
            if app.isFake { selectedFake = app }
        }
    }
}

struct AppIconView: View {
    let app: AppModel
    @ObservedObject var theme: ThemeManager

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: app.color))
                    .frame(width: 60, height: 60)
                    .shadow(color: Color(hex: app.color).opacity(0.35), radius: 8, y: 3)
                Image(systemName: app.iconName)
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }
            .opacity(app.isHidden ? 0.35 : 1.0)

            Text(app.name)
                .font(.system(size: 11))
                .foregroundColor(theme.textPrimary)
                .lineLimit(1)
        }
    }
}
