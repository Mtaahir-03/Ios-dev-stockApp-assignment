import SwiftUI

struct ColorTheme {
    // Base colors
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    
    // Text colors - automatically adapts to dark mode
    static let text = Color(UIColor.label)
    static let secondaryText = Color(UIColor.secondaryLabel)
    static let tertiaryText = Color(UIColor.tertiaryLabel)
    
    // Accent colors - consistent in both modes
    static let accent = Color(red: 0.18, green: 0.72, blue: 0.48)
    static let accentDark = Color(red: 0.13, green: 0.55, blue: 0.36)
    static let negative = Color(red: 0.92, green: 0.26, blue: 0.26)
    static let negativeDark = Color(red: 0.75, green: 0.22, blue: 0.22)
    
    // Chart colors - consistent in both modes
    static let chartLine = accent
    static let chartGradientTop = accent.opacity(0.3)
    static let chartGradientBottom = accent.opacity(0.0)
    
    // Card colors - automatically adapts to dark mode
    static let cardBackground = Color(UIColor.secondarySystemBackground)
    static let cardShadow = Color(UIColor.label).opacity(0.1)
}
