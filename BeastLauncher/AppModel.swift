import Foundation

struct AppModel: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var iconName: String       // SF Symbol name
    var color: String          // hex color string
    var isHidden: Bool = false
    var isFake: Bool = false
    var fakeScreenContent: String = ""
}

extension AppModel {
    static let defaults: [AppModel] = [
        AppModel(name: "Terminal", iconName: "terminal", color: "#00FF41", isFake: false),
        AppModel(name: "Files", iconName: "folder.fill", color: "#1E90FF", isFake: false),
        AppModel(name: "Widgets", iconName: "square.grid.2x2", color: "#FF6B6B", isFake: false),
        AppModel(name: "Settings", iconName: "gearshape.fill", color: "#8E8E93", isFake: false),
        AppModel(name: "Safari", iconName: "safari.fill", color: "#34C759", isFake: true, fakeScreenContent: "Safari is not available."),
        AppModel(name: "Messages", iconName: "message.fill", color: "#30D158", isFake: true, fakeScreenContent: "No messages."),
        AppModel(name: "Camera", iconName: "camera.fill", color: "#FF9500", isFake: true, fakeScreenContent: "Camera access denied."),
        AppModel(name: "Photos", iconName: "photo.fill", color: "#FF2D55", isFake: true, fakeScreenContent: "No photos found."),
        AppModel(name: "Maps", iconName: "map.fill", color: "#5AC8FA", isFake: true, fakeScreenContent: "Location unavailable."),
        AppModel(name: "Music", iconName: "music.note", color: "#FF375F", isFake: true, fakeScreenContent: "No media library."),
        AppModel(name: "Mail", iconName: "envelope.fill", color: "#007AFF", isFake: true, fakeScreenContent: "No accounts configured."),
        AppModel(name: "Clock", iconName: "clock.fill", color: "#1C1C1E", isFake: false),
    ]
}
