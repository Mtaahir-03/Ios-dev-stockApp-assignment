import SwiftUI

struct InteractivePriceChart: View {
    let priceData: [PriceData]
    let minY: Double
    let maxY: Double
    let isPositive: Bool
    
    @State private var selectedPoint: Int? = nil
    @State private var touchLocation: CGPoint = .zero
    
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
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                // Selected point value
                if let selectedPoint = selectedPoint, selectedPoint < priceData.count {
                    VStack(alignment: .leading) {
                        Text(dateFormatter.string(from: priceData[selectedPoint].timestamp))
                            .font(Typography.caption)
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text("$\(priceData[selectedPoint].price, specifier: "%.2f")")
                            .font(Typography.money)
                            .foregroundColor(ColorTheme.text)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .zIndex(1)
                } else {
                    // Default view showing latest price
                    VStack(alignment: .leading) {
                        Text(dateFormatter.string(from: priceData.last?.timestamp ?? Date()))
                            .font(Typography.caption)
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text("$\(priceData.last?.price ?? 0, specifier: "%.2f")")
                            .font(Typography.money)
                            .foregroundColor(ColorTheme.text)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .zIndex(1)
                }
                
                // Chart
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
                                path.move(to: CGPoint(x: 0, y: geometry.size.height))
                                
                                for (index, data) in priceData.enumerated() {
                                    let xPosition = geometry.size.width / CGFloat(priceData.count - 1) * CGFloat(index)
                                    let yPosition = geometry.size.height - CGFloat((data.price - minY) / (maxY - minY)) * geometry.size.height
                                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                                }
                                
                                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
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
                                    let yPosition = geometry.size.height - CGFloat((data.price - minY) / (maxY - minY)) * geometry.size.height
                                    
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
                            
                            // Selected point indicator
                            if let selectedPoint = selectedPoint, selectedPoint < priceData.count {
                                let xPosition = geometry.size.width / CGFloat(priceData.count - 1) * CGFloat(selectedPoint)
                                let yPosition = geometry.size.height - CGFloat((priceData[selectedPoint].price - minY) / (maxY - minY)) * geometry.size.height
                                
                                Circle()
                                    .fill(isPositive ? ColorTheme.accent : ColorTheme.negative)
                                    .frame(width: 12, height: 12)
                                    .position(x: xPosition, y: yPosition)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 1, height: geometry.size.height)
                                    .position(x: xPosition, y: geometry.size.height / 2)
                            }
                        }
                        
                        // Touch overlay
                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        touchLocation = value.location
                                        updateSelectedPoint(in: geometry.size)
                                    }
                                    .onEnded { _ in
                                        // Optionally keep or clear the selection
                                        // selectedPoint = nil
                                    }
                            )
                    }
                }
            }
            .frame(height: 250)
            .padding(.top)
            
            // Price range
            HStack {
                if let min = priceData.min(by: { $0.price < $1.price })?.price,
                   let max = priceData.max(by: { $0.price < $1.price })?.price {
                    Text("$\(min, specifier: "%.2f")")
                        .font(Typography.caption)
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Text("$\(max, specifier: "%.2f")")
                        .font(Typography.caption)
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func updateSelectedPoint(in size: CGSize) {
        guard !priceData.isEmpty else { return }
        
        let stepWidth = size.width / CGFloat(priceData.count - 1)
        let index = Int(touchLocation.x / stepWidth)
        
        selectedPoint = max(0, min(index, priceData.count - 1))
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
