//
//  Wallet.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import Foundation

struct Wallet: Identifiable {
    let id = UUID()
    let address: String
    let name: String
    var balances: [TokenBalance] = []
    
    var totalValueUSD: Double {
        balances.reduce(0) { $0 + $1.valueUSD }
    }
}
