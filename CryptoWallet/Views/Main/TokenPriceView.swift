import SwiftUI

struct TokenPriceView: View {
    let token: TokenBalance
    @StateObject private var viewModel = TokenPriceViewModel()
    @State private var timeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case day = "1D"
        case week = "1W"
        case month = "1M"
        case year = "1Y"
        case all = "All"
    }
    
    var priceChange: Double? {
        guard viewModel.priceHistory.count >= 2 else { return nil }
        let first = viewModel.priceHistory.first!.price
        let last = viewModel.priceHistory.last!.price
        return ((last - first) / first) * 100
    }
    
    var isPriceUp: Bool {
        return priceChange ?? 0 >= 0
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with price and change
                VStack(alignment: .leading, spacing: 8) {
                    Text(token.name)
                        .font(Typography.title)
                        .foregroundColor(ColorTheme.text)
                    
                    Text(token.symbol.uppercased())
                        .font(Typography.footnote)
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Text("$\(String(format: "%.2f", token.price))")
                        .font(Typography.moneyLarge)
                        .foregroundColor(ColorTheme.text)
                        .padding(.top, 4)
                    
                    if let change = priceChange {
                        HStack(spacing: 4) {
                            Image(systemName: isPriceUp ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                .font(.footnote)
                            
                            Text("\(String(format: "%.2f", abs(change)))%")
                                .font(Typography.bodyBold)
                        }
                        .foregroundColor(isPriceUp ? ColorTheme.accent : ColorTheme.negative)
                    }
                }
                .padding(.horizontal)
                
                // Chart period selection
                HStack {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Button {
                            withAnimation {
                                timeRange = range
                            }
                            Task {
                                await viewModel.fetchPriceHistory(for: token.symbol, range: range)
                            }
                        } label: {
                            Text(range.rawValue)
                                .font(Typography.footnote)
                                .fontWeight(timeRange == range ? .bold : .regular)
                                .foregroundColor(timeRange == range ?
                                                 (isPriceUp ? ColorTheme.accent : ColorTheme.negative) :
                                                    ColorTheme.secondaryText)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(timeRange == range ?
                                              (isPriceUp ? ColorTheme.accent.opacity(0.1) : ColorTheme.negative.opacity(0.1)) :
                                                Color.clear)
                                )
                        }
                        .id("timeRange-\(range)") // unique id to force refresh
                    }
                }
                .padding(.horizontal)
                
                // Price chart
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if viewModel.priceHistory.isEmpty {
                        Text("No price data available")
                            .font(Typography.body)
                            .foregroundColor(ColorTheme.secondaryText)
                            .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
                    } else {
                        CardView {
                            VStack(alignment: .leading, spacing: 16) {
                                PriceChartView(priceData: viewModel.priceHistory)
                                    .id("chart-\(timeRange)") // Force chart refresh when timeRange changes
                                
                                // Price range
                                HStack {
                                    if let min = viewModel.priceHistory.min(by: { $0.price < $1.price })?.price,
                                       let max = viewModel.priceHistory.max(by: { $0.price < $1.price })?.price {
                                        Text("$\(String(format: "%.2f", min))")
                                            .font(Typography.caption)
                                            .foregroundColor(ColorTheme.secondaryText)
                                        
                                        Spacer()
                                        
                                        Text("$\(String(format: "%.2f", max))")
                                            .font(Typography.caption)
                                            .foregroundColor(ColorTheme.secondaryText)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .id("chart-container-\(timeRange)") // id to ensure container refreshes
                
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Holdings")
                            .font(Typography.title3)
                            .foregroundColor(ColorTheme.text)
                        
                        Divider()
                        
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(token.formattedBalance) \(token.symbol)")
                                    .font(Typography.body)
                                
                                Text("Token Balance")
                                    .font(Typography.caption)
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                Text(token.formattedValueUSD)
                                    .font(Typography.money)
                                    .foregroundColor(ColorTheme.text)
                                
                                Text("Value in USD")
                                    .font(Typography.caption)
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Market data
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Market Data")
                            .font(Typography.title3)
                            .foregroundColor(ColorTheme.text)
                        
                        Divider()
                        
                        HStack {
                            Text("Token Address")
                                .font(Typography.body)
                                .foregroundColor(ColorTheme.text)
                            
                            Spacer()
                            
                            Text(token.tokenAddress.prefix(6) + "..." + token.tokenAddress.suffix(4))
                                .font(Typography.caption)
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Decimals")
                                .font(Typography.body)
                                .foregroundColor(ColorTheme.text)
                            
                            Spacer()
                            
                            Text("\(token.decimals)")
                                .font(Typography.caption)
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
                .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(Typography.caption)
                        .foregroundColor(ColorTheme.negative)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.fetchPriceHistory(for: token.symbol, range: timeRange)
            }
        }
    }
}

#Preview {
    TokenPriceView(token: TokenBalance(symbol: "eth", name: "Ethereum", balance: 1, decimals: 18, tokenAddress: "", price: 2000))
}
