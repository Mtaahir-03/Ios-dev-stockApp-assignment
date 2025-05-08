// PriceChartView.swift - Update this file
import SwiftUI

struct PriceChartView: View {
    let priceData: [PriceData]
    let minY: Double
    let maxY: Double
    let isPositive: Bool
    
    init(priceData: [PriceData]) {
        self.priceData = priceData
        self.minY = priceData.min(by: { $0.price < $1.price })?.price ?? 0
        self.maxY = priceData.max(by: { $0.price < $1.price })?.price ?? 0
        
        // Determine if trend is positive
        if priceData.count >= 2 {
            self.isPositive = priceData.last!.price >= priceData.first!.price
        } else {
            self.isPositive = true
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                VStack(spacing: geometry.size.height / 4) {
                    ForEach(0..<4) { _ in
                        Divider()
                            .background(Color.gray.opacity(0.2))
                    }
                }
                
                // Price line and area
                ZStack {
                    // Area fill
                    Path { path in
                        // Start at bottom left
                        path.move(to: CGPoint(x: 0, y: geometry.size.height))
                        
                        // For each price point, add a point to the path
                        for (index, data) in priceData.enumerated() {
                            let xPosition = geometry.size.width / CGFloat(priceData.count - 1) * CGFloat(index)
                            
                            let yRange = maxY - minY
                            let yPosition = geometry.size.height - CGFloat((data.price - minY) / yRange) * geometry.size.height
                            
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        
                        // Add bottom right point to complete the shape
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                        
                        // Close the path
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    isPositive ? ColorTheme.chartGradientTop : ColorTheme.negative.opacity(0.3),
                                    isPositive ? ColorTheme.chartGradientBottom : ColorTheme.negative.opacity(0.0)
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Line on top
                    Path { path in
                        for (index, data) in priceData.enumerated() {
                            let xPosition = geometry.size.width / CGFloat(priceData.count - 1) * CGFloat(index)
                            
                            let yRange = maxY - minY
                            let yPosition = geometry.size.height - CGFloat((data.price - minY) / yRange) * geometry.size.height
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: xPosition, y: yPosition))
                            } else {
                                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                            }
                        }
                    }
                    .stroke(
                        isPositive ? ColorTheme.chartLine : ColorTheme.negative,
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                    )
                }
            }
        }
        .frame(height: 200)
        .padding(.vertical)
    }
}
