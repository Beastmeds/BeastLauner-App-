import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var apps: [AppModel] = []
    @Published var showHidden: Bool = false
    @Published var selectedApp: AppModel? = nil
    @Published var showAddSheet: Bool = false

    private let storageKey = "beast_apps"

    init() {
        load()
    }

    var visibleApps: [AppModel] {
        showHidden ? apps : apps.filter { !$0.isHidden }
    }

    func toggleHidden(_ app: AppModel) {
        if let idx = apps.firstIndex(where: { $0.id == app.id }) {
            apps[idx].isHidden.toggle()
            save()
        }
    }

    func addApp(_ app: AppModel) {
        apps.append(app)
        save()
        LogSystem.shared.log("Added fake app: \(app.name)")
    }

    func deleteApp(_ app: AppModel) {
        apps.removeAll { $0.id == app.id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(apps) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([AppModel].self, from: data) {
            apps = decoded
        } else {
            apps = AppModel.defaults
        }
    }
}
