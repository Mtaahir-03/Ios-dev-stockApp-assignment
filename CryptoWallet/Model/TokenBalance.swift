//
//  TokenBalance.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import Foundation

struct TokenBalance: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    var balance: Double
    let decimals: Int
    let tokenAddress: String
    var price: Double = 0
    
    var formattedBalance: String {
        String(format: "%.4f", balance)
    }
    
    var valueUSD: Double {
        balance * price
    }
    
    var formattedValueUSD: String {
        String(format: "$%.2f", valueUSD)
    }
}
