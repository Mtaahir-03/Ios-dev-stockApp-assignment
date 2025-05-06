//
//  PriceData.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import Foundation

struct PriceData: Identifiable {
    let id = UUID()
    let timestamp: Date
    let price: Double
}
