//
//  TokenDatabaseView.swift
//  CryptoWallet
//
//  Created by Shaiyan Khan on 7/5/2025.
//
import SwiftUI

struct TokenDatabaseView: View {
    @ObservedObject var viewModel: WalletViewModel
    @State private var searchText = ""

    var filteredTokens: [TokenBalance] {
        var uniqueTokens: [String: TokenBalance] = [:]
        for wallet in viewModel.wallets {
            for token in wallet.balances {
                if let existing = uniqueTokens[token.tokenAddress] {
                    var updated = existing
                    updated.balance += token.balance
                    uniqueTokens[token.tokenAddress] = updated
                } else {
                    uniqueTokens[token.tokenAddress] = token
                }
            }
        }
        let all = Array(uniqueTokens.values)
        if searchText.isEmpty {
            return all
        } else {
            return all.filter {
                $0.symbol.localizedCaseInsensitiveContains(searchText) ||
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        List(filteredTokens) { token in
            VStack(alignment: .leading, spacing: 4) {
                Text(token.symbol)
                    .font(.headline)
                Text(token.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Balance: \(token.formattedBalance)")
                Text("USD Value: \(token.formattedValueUSD)")
                Text("Token Address: \(token.tokenAddress)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 6)
        }
        .searchable(text: $searchText)
        .navigationTitle("Token Database")
    }
}

#Preview {
    TokenDatabaseView(viewModel: WalletViewModel())
}


