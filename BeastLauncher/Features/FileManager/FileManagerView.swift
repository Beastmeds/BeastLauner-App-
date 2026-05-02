import SwiftUI

struct FileManagerView: View {
    @ObservedObject var theme: ThemeManager
    @State private var files: [BeastFile] = []
    @State private var showNew = false
    @State private var newName = ""
    @State private var newContent = ""
    @State private var selectedFile: BeastFile? = nil
    @State private var editContent = ""

    struct BeastFile: Identifiable, Codable {
        var id = UUID()
        var name: String
        var content: String
        var date: Date = Date()
    }

    private let key = "beast_files"

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundColor(theme.accent)
                Text("Files")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(theme.textPrimary)
                Spacer()
                Button(action: { showNew = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(theme.accent)
                }
            }
            .padding()
            .background(Color.white.opacity(0.04))

            if files.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 48))
                        .foregroundColor(theme.textSecondary)
                    Text("No files yet")
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
            } else {
                List {
                    ForEach(files) { file in
                        Button(action: {
                            selectedFile = file
                            editContent = file.content
                        }) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(theme.accent)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(file.name)
                                        .foregroundColor(theme.textPrimary)
                                        .font(.system(size: 15))
                                    Text(file.date, style: .date)
                                        .foregroundColor(theme.textSecondary)
                                        .font(.system(size: 12))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(theme.textSecondary)
                                    .font(.system(size: 12))
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.04))
                    }
                    .onDelete { idx in
                        files.remove(atOffsets: idx)
                        save()
                    }
                }
                .listStyle(.plain)
                
            }
        }
        .background(theme.background)
        .padding(.bottom, 90)
        .onAppear { load() }
        .sheet(isPresented: $showNew) {
            newFileSheet
        }
        .sheet(item: $selectedFile) { file in
            editFileSheet(file: file)
        }
    }

    var newFileSheet: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                VStack(spacing: 16) {
                    TextField("Filename", text: $newName)
                        .padding()
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(12)
                        .foregroundColor(theme.textPrimary)
                    TextEditor(text: $newContent)
                        .frame(minHeight: 200)
                        .padding()
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(12)
                        .foregroundColor(theme.textPrimary)
                        .font(.system(size: 14, design: .monospaced))
                }
                .padding()
            }
            .navigationTitle("New File")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showNew = false }.foregroundColor(theme.accent)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !newName.isEmpty else { return }
                        files.append(BeastFile(name: newName, content: newContent))
                        save()
                        newName = ""; newContent = ""; showNew = false
                        LogSystem.shared.log("File created: \(newName)")
                    }.foregroundColor(theme.accent)
                }
            }
        }
    }

    func editFileSheet(file: BeastFile) -> some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                TextEditor(text: $editContent)
                    .padding()
                    .foregroundColor(theme.textPrimary)
                    .font(.system(size: 14, design: .monospaced))
                    
            }
            .navigationTitle(file.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { selectedFile = nil }.foregroundColor(theme.accent)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let idx = files.firstIndex(where: { $0.id == file.id }) {
                            files[idx].content = editContent
                            save()
                        }
                        selectedFile = nil
                    }.foregroundColor(theme.accent)
                }
            }
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(files) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([BeastFile].self, from: data) {
            files = decoded
        }
    }
}
