import SwiftUI

struct LicenseView: View {
    @EnvironmentObject var licenseManager: LicenseManager
    @State private var keyInput: String = ""
    @State private var shake: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Background grid lines
            GeometryReader { geo in
                let cols = 8
                let rows = 16
                let cw = geo.size.width / CGFloat(cols)
                let rh = geo.size.height / CGFloat(rows)
                ForEach(0..<cols, id: \.self) { c in
                    Path { p in
                        p.move(to: CGPoint(x: CGFloat(c) * cw, y: 0))
                        p.addLine(to: CGPoint(x: CGFloat(c) * cw, y: geo.size.height))
                    }.stroke(Color(hex: "#00FF41").opacity(0.04), lineWidth: 0.5)
                }
                ForEach(0..<rows, id: \.self) { r in
                    Path { p in
                        p.move(to: CGPoint(x: 0, y: CGFloat(r) * rh))
                        p.addLine(to: CGPoint(x: geo.size.width, y: CGFloat(r) * rh))
                    }.stroke(Color(hex: "#00FF41").opacity(0.04), lineWidth: 0.5)
                }
            }

            VStack(spacing: 32) {
                Spacer()

                // Logo
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color(hex: "#007AFF"))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color(hex: "#007AFF").opacity(0.5), radius: 20)
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    Text("BeastLauncher")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Enter your license key to continue")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                // Input card
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("LICENSE KEY")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                            .tracking(1.5)

                        TextField("XXXX-XXXX-XXXXX", text: $keyInput)
                            .font(.system(size: 17, design: .monospaced))
                            .foregroundColor(.white)
                            .autocapitalization(.allCharacters)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        licenseManager.errorMessage.isEmpty
                                        ? Color.white.opacity(0.1)
                                        : Color.red.opacity(0.7),
                                        lineWidth: 1
                                    )
                            )
                    }

                    if !licenseManager.errorMessage.isEmpty {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text(licenseManager.errorMessage)
                        }
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .offset(x: shake ? -8 : 0)
                        .animation(.default, value: shake)
                    }

                    Button(action: {
                        licenseManager.validate(key: keyInput)
                        if !licenseManager.errorMessage.isEmpty {
                            shake = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { shake = false }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.shield")
                            Text("Activate")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#007AFF"))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: Color(hex: "#007AFF").opacity(0.4), radius: 10)
                    }
                }
                .padding(24)
                .background(Color.white.opacity(0.04))
                .cornerRadius(20)
                .padding(.horizontal, 24)

                Spacer()

                Text("v1.0 · BeastSMP")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.bottom, 8)
            }
        }
    }
}
