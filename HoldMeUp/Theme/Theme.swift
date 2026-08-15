import SwiftUI

private extension UIColor {
    convenience init(hex: String) {
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        sanitized = sanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

private func dynamicColor(light: String, dark: String) -> Color {
    Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
    })
}

/// Color tokens ported from the locked mockup (light + dark both defined there).
enum Theme {
    static let background = dynamicColor(light: "EEF5F0", dark: "0E1613")
    static let surface = dynamicColor(light: "FFFFFF", dark: "16211C")
    static let surface2 = dynamicColor(light: "F5FAF6", dark: "1C2721")
    static let surfaceBorder = dynamicColor(light: "DCE8DF", dark: "25352C")
    static let ink = dynamicColor(light: "152420", dark: "EAF3EE")
    static let inkSoft = dynamicColor(light: "57685F", dark: "9FB3A9")
    static let inkFaint = dynamicColor(light: "8B9C93", dark: "6C8177")
    static let accent = dynamicColor(light: "1F9D55", dark: "3ECB78")
    static let accentTint = dynamicColor(light: "DFF3E6", dark: "173A26")
    static let warn = dynamicColor(light: "B8791E", dark: "F0B458")
    static let warnTint = dynamicColor(light: "FCEED8", dark: "3A2E13")
    static let bad = dynamicColor(light: "C23A3F", dark: "F0666B")
    static let badTint = dynamicColor(light: "FBE1E1", dark: "3A1516")

    static func playerColor(for avatar: AvatarOption) -> Color {
        switch avatar {
        case .parrot: return dynamicColor(light: "FF6B4A", dark: "FF8064")
        case .elephant: return dynamicColor(light: "2E9BD6", dark: "57B4EE")
        case .dog: return dynamicColor(light: "DE9B15", dark: "F5C55C")
        case .cat: return dynamicColor(light: "8B6BEF", dark: "A98CFF")
        case .lion: return dynamicColor(light: "E14876", dark: "FF7996")
        }
    }
}
