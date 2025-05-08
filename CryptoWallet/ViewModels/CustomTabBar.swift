// CustomTabBar.swift - Create this new file
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabItems: [TabItem]
    
    struct TabItem {
        let icon: String
        let selectedIcon: String
        let title: String
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            ForEach(0..<tabItems.count, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == index ? tabItems[index].selectedIcon : tabItems[index].icon)
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == index ? ColorTheme.accent : ColorTheme.secondaryText)
                        
                        Text(tabItems[index].title)
                            .font(.system(size: 10))
                            .foregroundColor(selectedTab == index ? ColorTheme.accent : ColorTheme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(
            Rectangle()
                .fill(ColorTheme.cardBackground)
                .shadow(color: ColorTheme.cardShadow, radius: 4, x: 0, y: -2)
        )
    }
}
