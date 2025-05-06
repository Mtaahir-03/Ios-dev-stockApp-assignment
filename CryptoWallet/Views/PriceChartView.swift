//
//  PriceChartView.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct PriceChartView: View {
    let priceData: [PriceData]
    let minY: Double
    let maxY: Double
    
    init(priceData: [PriceData]) {
        self.priceData = priceData
        self.minY = priceData.min(by: { $0.price < $1.price })?.price ?? 0
        self.maxY = priceData.max(by: { $0.price < $1.price })?.price ?? 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Y-axis grid lines
                VStack(alignment: .leading) {
                    ForEach(0..<5) { i in
                        Divider()
                            .frame(height: 1)
                            .background(Color.gray.opacity(0.2))
                            .padding(.bottom, geometry.size.height / 5)
                    }
                }
                
                // Price line
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
                .stroke(Color.blue, lineWidth: 2)
            }
        }
        .frame(height: 200)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    PriceChartView(priceData: [PriceData(timestamp: Date(), price: 2.50), PriceData(timestamp: Date(), price: 2.70)])
}
