import SwiftUI

struct FakeAppScreen: View {
    let app: AppModel
    @ObservedObject var theme: ThemeManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(theme.accent)
                    }
                    Spacer()
                }
                .padding()

                Spacer()
                Image(systemName: app.iconName)
                    .font(.system(size: 64))
                    .foregroundColor(Color(hex: app.color))
                Text(app.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(theme.textPrimary)
                Text(app.fakeScreenContent.isEmpty ? "This app is unavailable." : app.fakeScreenContent)
                    .font(.system(size: 15))
                    .foregroundColor(theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
}

struct AddFakeAppSheet: View {
    @ObservedObject var vm: HomeViewModel
    @ObservedObject var theme: ThemeManager
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var icon = "star.fill"
    @State private var color = "#FF6B6B"
    @State private var content = ""

    let icons = ["star.fill","bolt.fill","flame.fill","heart.fill","shield.fill","lock.fill",
                 "globe","camera.fill","music.note","gamecontroller.fill","cpu","wifi"]

    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                Form {
                    Section(header: Text("App Info").foregroundColor(theme.textSecondary)) {
                        TextField("App Name", text: $name)
                            .foregroundColor(theme.textPrimary)
                        TextField("Screen Content", text: $content)
                            .foregroundColor(theme.textPrimary)
                        TextField("Color (hex)", text: $color)
                            .foregroundColor(theme.textPrimary)
                            .autocapitalization(.none)
                    }
                    Section(header: Text("Icon").foregroundColor(theme.textSecondary)) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                            ForEach(icons, id: \.self) { ic in
                                Image(systemName: ic)
                                    .font(.system(size: 22))
                                    .foregroundColor(ic == icon ? theme.accent : theme.textSecondary)
                                    .padding(8)
                                    .background(ic == icon ? theme.accent.opacity(0.15) : Color.clear)
                                    .cornerRadius(8)
                                    .onTapGesture { icon = ic }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Fake App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundColor(theme.accent)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !name.isEmpty else { return }
                        let app = AppModel(name: name, iconName: icon, color: color,
                                          isFake: true, fakeScreenContent: content)
                        vm.addApp(app)
                        dismiss()
                    }.foregroundColor(theme.accent)
                }
            }
        }
    }
}
