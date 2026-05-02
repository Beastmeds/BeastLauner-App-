# BeastLauncher

iOS Fake Launcher App — SwiftUI · License System · Dark/Hacker Mode

## License Keys
```
BEAST-1234-ACCESS
DEV-9999-TEST
NICO-2026-ULTRA
```

---

## 1. Projekt auf GitHub hochladen

```bash
cd BeastLauncher
git init
git add .
git commit -m "Initial commit: BeastLauncher v1.0"
git branch -M main
git remote add origin https://github.com/Beastmeds/BeastLauncher.git
git push -u origin main
```

---

## 2. Codemagic Build starten

1. Gehe auf [codemagic.io](https://codemagic.io) → **Add application**
2. GitHub Repo verbinden: `Beastmeds/BeastLauncher`
3. **"Use codemagic.yaml"** auswählen
4. Workflow: `ios-release` → **Start new build**

Build dauert ~5-10 Minuten. Am Ende bekommst du:
- `BeastLauncher.ipa` → Download Artifact

---

## 3. IPA installieren mit ESign

1. **ESign** auf iPhone öffnen (via IPA Library oder Sideloadly vorinstalliert)
2. Importiere `BeastLauncher.ipa` über AirDrop, Files oder Browser-Download
3. ESign → **Apps** → **+** → IPA auswählen
4. **Sign** → eigenes Zertifikat wählen → **Install**
5. Einstellungen → Allgemein → VPN & Geräteverwaltung → Zertifikat vertrauen

---

## Features

| Feature | Status |
|---|---|
| License System (UserDefaults) | ✅ |
| Fake iOS Homescreen Grid | ✅ |
| Apps verstecken (Toggle) | ✅ |
| Fake Apps erstellen | ✅ |
| Fake Terminal (help, clear, ls, ...) | ✅ |
| File Manager (lokal, Sandbox) | ✅ |
| Clock + Text Widgets | ✅ |
| Dark Mode | ✅ |
| Hacker Mode (Grün/Schwarz) | ✅ |
| Debug Log | ✅ |

---

## Ordnerstruktur

```
BeastLauncher/
├── App/
│   ├── BeastLauncherApp.swift
│   ├── RootView.swift
│   └── Info.plist
├── Core/
│   ├── LicenseManager.swift
│   ├── AppModel.swift
│   ├── LogSystem.swift
│   └── ThemeManager.swift
├── Features/
│   ├── LicenseView.swift
│   ├── HomeViewModel.swift
│   ├── HomeView.swift
│   ├── AppGridView.swift
│   ├── FakeAppScreens.swift
│   ├── TerminalView.swift
│   ├── FileManagerView.swift
│   └── WidgetView.swift
└── UI/
    └── UIComponents.swift
```
