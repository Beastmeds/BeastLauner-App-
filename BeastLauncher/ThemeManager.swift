import SwiftUI

class ThemeManager: ObservableObject {
    @Published var hackerMode: Bool = false

    var background: Color {
        hackerMode ? Color.black : Color(hex: "#0A0A0F")
    }
    var accent: Color {
        hackerMode ? Color(hex: "#00FF41") : Color(hex: "#007AFF")
    }
    var secondary: Color {
        hackerMode ? Color(hex: "#00AA2A") : Color(hex: "#5AC8FA")
    }
    var textPrimary: Color {
        hackerMode ? Color(hex: "#00FF41") : Color.white
    }
    var textSecondary: Color {
        hackerMode ? Color(hex: "#00AA2A") : Color(hex: "#EBEBF5").opacity(0.6)
    }
    var fontName: String {
        hackerMode ? "Courier New" : "SF Pro Display"
    }
}

extension Color {
    init(hex: String) {
        var h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        if h.count == 6 { h = "FF" + h }
        let v = UInt64(h, radix: 16) ?? 0
        self.init(
            .sRGB,
            red: Double((v >> 16) & 0xFF) / 255,
            green: Double((v >> 8) & 0xFF) / 255,
            blue: Double(v & 0xFF) / 255,
            opacity: Double((v >> 24) & 0xFF) / 255
        )
    }
}
