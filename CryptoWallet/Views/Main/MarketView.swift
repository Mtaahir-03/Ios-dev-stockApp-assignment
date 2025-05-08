import SwiftUI

struct MarketView: View {
    @ObservedObject var viewModel: WalletViewModel
    @State private var searchText = ""
    
    var filteredTokens: [TokenBalance] {
        if searchText.isEmpty {
            return allTokens
        } else {
            return allTokens.filter {
                $0.symbol.localizedCaseInsensitiveContains(searchText) ||
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var allTokens: [TokenBalance] {
        var uniqueTokens: [String: TokenBalance] = [:]
        
        for wallet in viewModel.wallets {
            for token in wallet.balances {
                if let existingToken = uniqueTokens[token.symbol] {
                    var updatedToken = existingToken
                    updatedToken.balance += token.balance
                    uniqueTokens[token.symbol] = updatedToken
                } else {
                    uniqueTokens[token.symbol] = token
                }
            }
        }
        
        return Array(uniqueTokens.values).sorted { $0.valueUSD > $1.valueUSD }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredTokens) { token in
                    NavigationLink(destination: TokenPriceView(token: token)) {
                        CardView {
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
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(token.symbol)
                                        .font(Typography.bodyBold)
                                        .foregroundColor(ColorTheme.text)
                                    
                                    Text(token.name)
                                        .font(Typography.caption)
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("$\(String(format: "%.2f", token.price))")
                                        .font(Typography.bodyBold)
                                        .foregroundColor(ColorTheme.text)
                                    
                                    // Random price change for demo purposes
                                    let randomChange = Double.random(in: -5...5)
                                    HStack(spacing: 2) {
                                        Image(systemName: randomChange >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                            .font(.caption2)
                                        
                                        Text("\(String(format: "%.2f", abs(randomChange)))%")
                                            .font(Typography.caption)
                                    }
                                    .foregroundColor(randomChange >= 0 ? ColorTheme.accent : ColorTheme.negative)
                                }
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .searchable(text: $searchText, prompt: "Search tokens")
        .navigationTitle("Market")
        .background(ColorTheme.background.edgesIgnoringSafeArea(.all))
        .overlay {
            if allTokens.isEmpty {
                ContentUnavailableView(
                    "No Tokens Found",
                    systemImage: "magnifyingglass",
                    description: Text("Add a wallet to see your tokens.")
                )
            }
        }
    }
}
