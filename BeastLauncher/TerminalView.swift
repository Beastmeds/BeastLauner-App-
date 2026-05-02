import SwiftUI

struct TerminalView: View {
    @ObservedObject var theme: ThemeManager
    @State private var input: String = ""
    @State private var history: [TerminalLine] = [
        TerminalLine(text: "BeastLauncher Terminal v1.0", type: .system),
        TerminalLine(text: "Type 'help' for available commands.", type: .system),
    ]
    @FocusState private var focused: Bool

    struct TerminalLine: Identifiable {
        let id = UUID()
        let text: String
        let type: LineType
        enum LineType { case system, input, output, error }

        var color: Color {
            switch type {
            case .system: return Color(hex: "#5AC8FA")
            case .input:  return Color(hex: "#00FF41")
            case .output: return Color.white.opacity(0.85)
            case .error:  return Color(hex: "#FF453A")
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "terminal")
                    .foregroundColor(theme.accent)
                Text("Terminal")
                    .font(.system(size: 17, weight: .semibold, design: .monospaced))
                    .foregroundColor(theme.textPrimary)
                Spacer()
                Button(action: { history = [TerminalLine(text: "Cleared.", type: .system)] }) {
                    Image(systemName: "trash")
                        .foregroundColor(theme.textSecondary)
                }
            }
            .padding()
            .background(Color.white.opacity(0.04))

            // Output
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(history) { line in
                            HStack(alignment: .top, spacing: 0) {
                                if line.type == .input {
                                    Text("$ ")
                                        .foregroundColor(theme.accent)
                                        .font(.system(size: 14, design: .monospaced))
                                }
                                Text(line.text)
                                    .foregroundColor(line.color)
                                    .font(.system(size: 14, design: .monospaced))
                                    .textSelection(.enabled)
                                Spacer()
                            }
                            .id(line.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: history.count) { _ in
                    if let last = history.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            // Input
            HStack(spacing: 8) {
                Text("$")
                    .foregroundColor(theme.accent)
                    .font(.system(size: 16, design: .monospaced))
                TextField("enter command...", text: $input)
                    .font(.system(size: 15, design: .monospaced))
                    .foregroundColor(theme.textPrimary)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focused)
                    .onSubmit { execute() }
                Button(action: execute) {
                    Image(systemName: "return")
                        .foregroundColor(theme.accent)
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .padding(.bottom, 90)
        }
        .background(theme.background)
        .onAppear { focused = true }
    }

    private func execute() {
        let cmd = input.trimmingCharacters(in: .whitespaces)
        guard !cmd.isEmpty else { return }
        history.append(TerminalLine(text: cmd, type: .input))
        input = ""
        let response = process(cmd)
        history.append(contentsOf: response)
        LogSystem.shared.log("Terminal: \(cmd)")
    }

    private func process(_ cmd: String) -> [TerminalLine] {
        let parts = cmd.lowercased().split(separator: " ").map(String.init)
        switch parts.first ?? "" {
        case "help":
            return [
                TerminalLine(text: "Available commands:", type: .output),
                TerminalLine(text: "  help       - Show this message", type: .output),
                TerminalLine(text: "  clear      - Clear terminal", type: .output),
                TerminalLine(text: "  whoami     - Print user info", type: .output),
                TerminalLine(text: "  uname      - System info", type: .output),
                TerminalLine(text: "  date       - Current date/time", type: .output),
                TerminalLine(text: "  echo <txt> - Echo text", type: .output),
                TerminalLine(text: "  ls         - List files", type: .output),
                TerminalLine(text: "  ping       - Network test", type: .output),
                TerminalLine(text: "  version    - App version", type: .output),
            ]
        case "clear":
            DispatchQueue.main.async {
                history = [TerminalLine(text: "Terminal cleared.", type: .system)]
            }
            return []
        case "whoami":
            return [TerminalLine(text: "beast-user@BeastLauncher", type: .output)]
        case "uname":
            return [TerminalLine(text: "BeastOS 1.0.0 iOS-kernel ARM64", type: .output)]
        case "date":
            return [TerminalLine(text: "\(Date())", type: .output)]
        case "echo":
            let msg = parts.dropFirst().joined(separator: " ")
            return [TerminalLine(text: msg.isEmpty ? "" : msg, type: .output)]
        case "ls":
            return [
                TerminalLine(text: "Documents/", type: .output),
                TerminalLine(text: "Cache/", type: .output),
                TerminalLine(text: "Logs/", type: .output),
                TerminalLine(text: "BeastConfig.json", type: .output),
            ]
        case "ping":
            return [TerminalLine(text: "PING beast.local: 64 bytes, time=1.2ms", type: .output)]
        case "version":
            return [TerminalLine(text: "BeastLauncher v1.0.0 (build 1)", type: .output)]
        default:
            return [TerminalLine(text: "command not found: \(cmd)", type: .error)]
        }
    }
}
