import SwiftUI

struct PortfolioDonutChart: View {
    let tokens: [TokenBalance]
    
    var totalValue: Double {
        tokens.reduce(0) { $0 + $1.valueUSD }
    }
    
    var body: some View {
        ZStack {
            // Empty background circle
            Circle()
                .stroke(ColorTheme.secondaryBackground, lineWidth: 24)
            
            // Token segments
            ForEach(segments.indices, id: \.self) { index in
                let segment = segments[index]
                Circle()
                    .trim(from: segment.startAngle, to: segment.endAngle)
                    .stroke(segment.color, lineWidth: 24)
                    .rotationEffect(.degrees(-90))
            }
            
            // Center text
            VStack(spacing: 4) {
                Text("$\(totalValue, specifier: "%.2f")")
                    .font(Typography.moneyLarge)
                    .foregroundColor(ColorTheme.text)
                
                Text("Total Value")
                    .font(Typography.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .frame(height: 250)
        .padding()
    }
    
    private struct Segment {
        let startAngle: Double
        let endAngle: Double
        let color: Color
    }
    
    private var segments: [Segment] {
        // Create unique colors for each token
        let colors: [Color] = [
            ColorTheme.accent,
            Color(red: 0.2, green: 0.6, blue: 0.9),
            Color(red: 0.95, green: 0.6, blue: 0.1),
            Color(red: 0.8, green: 0.4, blue: 0.9),
            Color(red: 0.6, green: 0.8, blue: 0.2)
        ]
        
        var segments: [Segment] = []
        var startAngle: Double = 0
        
        // Sort tokens by value
        let sortedTokens = tokens.sorted { $0.valueUSD > $1.valueUSD }
        
        for (index, token) in sortedTokens.enumerated() {
            let percentage = token.valueUSD / totalValue
            let endAngle = startAngle + percentage
            
            // Use modulo to cycle through colors for many tokens
            let colorIndex = index % colors.count
            
            segments.append(Segment(
                startAngle: startAngle,
                endAngle: endAngle,
                color: colors[colorIndex]
            ))
            
            startAngle = endAngle
        }
        
        return segments
    }
}
