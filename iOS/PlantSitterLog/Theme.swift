import SwiftUI

/// Unique palette for Plant Sitter Log: Keep watering and feeding schedules per houseplant so sitters and family know exactly what to do.
enum Theme {
    static let accent = Color(hex: "#4C9A2A")
    static let accent2 = Color(hex: "#F7C548")
    static let background = Color(hex: "#0E1B0A")
    static let cardBackground = Color(hex: "#0E1B0A").opacity(0.06)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var rgb: UInt64 = 0
        Scanner(string: hexString.replacingOccurrences(of: "#", with: "")).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
