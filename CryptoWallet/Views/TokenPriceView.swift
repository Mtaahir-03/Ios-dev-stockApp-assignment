//
//  TokenPriceView.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct TokenPriceView: View {
    let token: TokenBalance
    @StateObject private var viewModel = TokenPriceViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(token.name)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(String(format: "%.2f", token.price))")
                            .font(.title2)
                            .bold()
                        
                        if !viewModel.priceHistory.isEmpty, let lastChange = calculatePriceChange() {
                            Text(lastChange > 0 ? "+\(String(format: "%.2f", lastChange))%" : "\(String(format: "%.2f", lastChange))%")
                                .foregroundColor(lastChange > 0 ? .green : .red)
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if viewModel.priceHistory.isEmpty {
                    Text("No price data available")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    VStack(alignment: .leading) {
                        Text("7-Day Price History")
                            .font(.headline)
                        
                        PriceChartView(priceData: viewModel.priceHistory)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Holdings")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(token.formattedBalance)
                                    .font(.title3)
                                Text(token.symbol)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(token.formattedValueUSD)
                                .font(.title3)
                                .bold()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Price Data")
                            .font(.headline)
                        
                        ForEach(viewModel.priceHistory) { data in
                            HStack {
                                Text(dateFormatter.string(from: data.timestamp))
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.2f", data.price))")
                                    .bold()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("\(token.symbol) Price")
        .onAppear {
            Task {
                await viewModel.fetchPriceHistory(for: token.symbol)
            }
        }
    }
    
    private func calculatePriceChange() -> Double? {
        guard viewModel.priceHistory.count >= 2 else { return nil }
        let first = viewModel.priceHistory.first!.price
        let last = viewModel.priceHistory.last!.price
        
        return ((last - first) / first) * 100
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    TokenPriceView(token: TokenBalance(symbol: "ETH", name: "Ethereum", balance: 2.5, decimals: 4, tokenAddress: "String", price: 15000))
}
