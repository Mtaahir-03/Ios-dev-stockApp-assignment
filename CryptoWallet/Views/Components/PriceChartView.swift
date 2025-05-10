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
        self.isPositive = priceData.count >= 2 ? priceData.last!.price >= priceData.first!.price : true
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }

    private var yTicks: [Double] {
        stride(from: maxY, through: minY, by: -(maxY - minY) / 4).map { $0 }
    }

    private var xTickIndices: [Int] {
        let step = max(1, priceData.count / 6)
        return Array(stride(from: 0, to: priceData.count, by: step))
    }

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let chartWidth = geometry.size.width - 60
                let chartHeight = geometry.size.height

                ZStack(alignment: .topLeading) {
                    // Y-axis grid lines
                    VStack(spacing: 0) {
                        ForEach(yTicks, id: \.self) { value in
                            HStack(spacing: 4) {
                                Text("$\(String(format: "%.2f", value))")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .frame(width: 60, alignment: .trailing)

                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 1)
                            }
                            .frame(height: chartHeight / CGFloat(yTicks.count - 1))
                        }
                    }

                    // Chart area and line
                    ZStack {
                        // Area fill
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: chartHeight))
                            for (index, data) in priceData.enumerated() {
                                let x = chartWidth / CGFloat(priceData.count - 1) * CGFloat(index)
                                let yRange = maxY - minY
                                let y = chartHeight - CGFloat((data.price - minY) / yRange) * chartHeight
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                            path.addLine(to: CGPoint(x: chartWidth, y: chartHeight))
                            path.closeSubpath()
                        }
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    isPositive ? ColorTheme.chartGradientTop : ColorTheme.negative.opacity(0.3),
                                    isPositive ? ColorTheme.chartGradientBottom : ColorTheme.negative.opacity(0.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                        // Price line
                        Path { path in
                            for (index, data) in priceData.enumerated() {
                                let x = chartWidth / CGFloat(priceData.count - 1) * CGFloat(index)
                                let yRange = maxY - minY
                                let y = chartHeight - CGFloat((data.price - minY) / yRange) * chartHeight

                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(
                            isPositive ? ColorTheme.chartLine : ColorTheme.negative,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                        )
                    }
                    .padding(.leading, 60)
                    .padding(.trailing, 8)
                }
            }
            .frame(height: 200)
            .padding(.bottom, 8)

            // X-axis labels only (no prices below)
            HStack(spacing: 0) {
                ForEach(xTickIndices, id: \.self) { index in
                    Text(dateFormatter.string(from: priceData[index].timestamp))
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.leading, 60)
            .padding(.top, 6)
        }
        .padding(.top)
    }
}
