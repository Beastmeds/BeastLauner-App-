import SwiftUI

struct WidgetView: View {
    @ObservedObject var theme: ThemeManager
    @State private var customText: String = "BeastSMP"
    @State private var editingText: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "square.grid.2x2")
                    .foregroundColor(theme.accent)
                Text("Widgets")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(theme.textPrimary)
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.04))

            ScrollView {
                VStack(spacing: 20) {
                    // Clock Widget
                    ClockWidget(theme: theme)

                    // Text Widget
                    TextWidget(theme: theme, text: $customText, editing: $editingText)

                    // Date Widget
                    DateWidget(theme: theme)
                }
                .padding()
                .padding(.bottom, 100)
            }
        }
        .background(theme.background)
    }
}

struct ClockWidget: View {
    @ObservedObject var theme: ThemeManager
    @State private var time = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )

            VStack(spacing: 4) {
                Text(time, style: .time)
                    .font(.system(size: 52, weight: .thin, design: .default))
                    .foregroundColor(theme.textPrimary)
                Text(time, style: .date)
                    .font(.system(size: 15))
                    .foregroundColor(theme.textSecondary)
            }
            .padding(24)
        }
        .onReceive(timer) { t in time = t }
    }
}

struct TextWidget: View {
    @ObservedObject var theme: ThemeManager
    @Binding var text: String
    @Binding var editing: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(theme.accent.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(theme.accent.opacity(0.25), lineWidth: 1)
                )

            VStack(spacing: 8) {
                HStack {
                    Text("TEXT WIDGET")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(theme.accent)
                        .tracking(1.5)
                    Spacer()
                    Button(action: { editing = true }) {
                        Image(systemName: "pencil.circle")
                            .foregroundColor(theme.accent)
                    }
                }

                if editing {
                    TextField("Enter text...", text: $text)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(theme.textPrimary)
                        .multilineTextAlignment(.center)
                        .onSubmit { editing = false }
                } else {
                    Text(text)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(theme.textPrimary)
                }
            }
            .padding(20)
        }
    }
}

struct DateWidget: View {
    @ObservedObject var theme: ThemeManager

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(theme.textSecondary)
                        .tracking(1.5)
                    Text(Date(), style: .date)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(theme.textPrimary)
                }
                Spacer()
                Image(systemName: "calendar")
                    .font(.system(size: 32))
                    .foregroundColor(theme.accent)
            }
            .padding(20)
        }
    }
}
