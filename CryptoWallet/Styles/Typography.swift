import SwiftUI

struct Typography {
    // Headings
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.semibold)
    static let title2 = Font.title2.weight(.semibold)
    static let title3 = Font.title3.weight(.semibold)
    
    // Body text
    static let body = Font.body
    static let bodyBold = Font.body.weight(.semibold)
    
    // Other styles
    static let caption = Font.caption
    static let caption2 = Font.caption2
    static let footnote = Font.footnote
    static let footnoteLight = Font.footnote.weight(.light)
    
    // Money values
    static let money = Font.system(.title2, design: .rounded).weight(.semibold)
    static let moneyLarge = Font.system(.title, design: .rounded).weight(.bold)
    static let moneySmall = Font.system(.body, design: .rounded).weight(.semibold)
}
