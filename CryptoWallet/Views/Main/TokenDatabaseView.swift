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
        
        let all = Array(uniqueTokens.values).sorted { $0.name < $1.name }
        
        if searchText.isEmpty {
            return all
        } else {
            return all.filter {
                $0.symbol.localizedCaseInsensitiveContains(searchText) ||
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.tokenAddress.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredTokens) { token in
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                // Token icon placeholder
                                Circle()
                                    .fill(token.symbol.hashValue % 2 == 0 ? ColorTheme.accent.opacity(0.2) : ColorTheme.negative.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(token.symbol.prefix(1)))
                                            .font(.headline)
                                            .foregroundColor(token.symbol.hashValue % 2 == 0 ? ColorTheme.accent : ColorTheme.negative)
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(token.symbol)
                                        .font(Typography.bodyBold)
                                        .foregroundColor(ColorTheme.text)
                                    
                                    Text(token.name)
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("$\(String(format: "%.2f", token.price))")
                                        .font(Typography.bodyBold)
                                        .foregroundColor(ColorTheme.text)
                                    
                                    Text("\(token.formattedBalance) \(token.symbol)")
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Token Address")
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.secondaryText)
                                    
                                    Spacer()
                                    
                                    Text(token.tokenAddress.prefix(10) + "..." + token.tokenAddress.suffix(10))
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(ColorTheme.tertiaryText)
                                }
                                
                                HStack {
                                    Text("Decimals")
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.secondaryText)
                                    
                                    Spacer()
                                    
                                    Text("\(token.decimals)")
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.tertiaryText)
                                }
                                
                                HStack {
                                    Text("USD Value")
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.secondaryText)
                                    
                                    Spacer()
                                    
                                    Text(token.formattedValueUSD)
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.tertiaryText)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .searchable(text: $searchText, prompt: "Search tokens by name, symbol, or address")
        .navigationTitle("Token Database")
        .background(ColorTheme.background.edgesIgnoringSafeArea(.all))
        .overlay {
            if filteredTokens.isEmpty {
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "No Tokens Found",
                        systemImage: "bitcoinsign.circle",
                        description: Text("Add a wallet to see your tokens in the database.")
                    )
                } else {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching with different keywords.")
                    )
                }
            }
        }
    }
}
