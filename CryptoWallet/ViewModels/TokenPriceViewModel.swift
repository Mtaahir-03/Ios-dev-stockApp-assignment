//
//  TokenPriceViewModel.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import Foundation

class TokenPriceViewModel: ObservableObject {
    @Published var priceHistory: [PriceData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let coinGeckoAPI = CoinGeckoAPI()
    
    func fetchPriceHistory(for symbol: String, range: TokenPriceView.TimeRange) async {
        let days: Int
        switch range {
        case .day: days = 1
        case .week: days = 7
        case .month: days = 30
        case .year: days = 365
        case .all: days = 365
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let history = try await coinGeckoAPI.getPriceHistory(for: symbol, days: days)
            
            await MainActor.run {
                priceHistory = history
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to fetch price history: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
