//
//  Cryptocurrency.swift
//  CryptoWallet
//
//  Created by ウェルン on 3/5/2025.
//

import Foundation

struct Cryptocurrency: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let balance: Double
    let value: Double
}
