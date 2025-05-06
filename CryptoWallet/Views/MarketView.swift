//
//  MarketView.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct MarketView: View {
    @ObservedObject var viewModel: WalletViewModel
    
    var allTokens: [TokenBalance] {
        var uniqueTokens: [String: TokenBalance] = [:] // track unique tokens in user wallets
        
        for wallet in viewModel.wallets {
            for token in wallet.balances {
                // if this token already in another wallet, update balance
                if let existingToken = uniqueTokens[token.symbol] {
                    var updatedToken = existingToken
                    updatedToken.balance += token.balance
                    uniqueTokens[token.symbol] = updatedToken
                } else {
                    uniqueTokens[token.symbol] = token
                }
            }
        }
        
        return Array(uniqueTokens.values)
    }
    
    var body: some View {
        List {
            ForEach(allTokens) { token in
                NavigationLink(destination: TokenPriceView(token: token)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(token.symbol)
                                .font(.headline)
                            Text(token.name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("$\(String(format: "%.2f", token.price))")
                                .bold()
                            Text("\(token.formattedBalance) (\(token.formattedValueUSD))")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Market")
        .overlay {
            if allTokens.isEmpty {
                Text("No tokens found")
                    .foregroundColor(.secondary)
            }
        }
    }
}


#Preview {
    MarketView(viewModel: WalletViewModel())
}
