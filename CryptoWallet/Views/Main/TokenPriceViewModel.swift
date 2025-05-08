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
    
    private let moralisAPI = MoralisAPI()
    
    func fetchPriceHistory(for symbol: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let history = try await moralisAPI.getPriceHistory(for: symbol)
            
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
