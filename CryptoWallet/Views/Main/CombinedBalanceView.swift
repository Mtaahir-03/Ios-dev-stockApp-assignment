import SwiftUI

struct CombinedBalanceView: View {
    @ObservedObject var viewModel: WalletViewModel
    @State private var showingAddWallet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with total balance
                VStack(spacing: 8) {
                    Text("Total Portfolio Value")
                        .font(Typography.title3)
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Text(viewModel.formattedTotalBalanceUSD)
                        .font(Typography.moneyLarge)
                        .foregroundColor(ColorTheme.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // Wallets section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Wallets")
                        .font(Typography.title3)
                        .foregroundColor(ColorTheme.text)
                        .padding(.horizontal)
                    
                    if viewModel.wallets.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "wallet.pass")
                                .font(.system(size: 40))
                                .foregroundColor(ColorTheme.secondaryText)
                                .padding()
                            
                            Text("No wallets added yet")
                                .font(Typography.body)
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            Button("Add Your First Wallet") {
                                showingAddWallet = true
                            }
                            .buttonStyle(AddWalletButtonStyle())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(viewModel.wallets) { wallet in
                            NavigationLink(destination: WalletDetailView(wallet: wallet)) {
                                CardView {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(wallet.name)
                                                .font(Typography.bodyBold)
                                                .foregroundColor(ColorTheme.text)
                                            
                                            Text(wallet.address.prefix(6) + "..." + wallet.address.suffix(4))
                                                .font(Typography.caption)
                                                .foregroundColor(ColorTheme.secondaryText)
                                            
                                            if !wallet.balances.isEmpty {
                                                Text("\(wallet.balances.count) tokens")
                                                    .font(Typography.footnote)
                                                    .foregroundColor(ColorTheme.tertiaryText)
                                                    .padding(.top, 4)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text(String(format: "$%.2f", wallet.totalValueUSD))
                                                .font(Typography.money)
                                                .foregroundColor(ColorTheme.text)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(ColorTheme.secondaryText)
                                                .padding(.top, 4)
                                        }
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .background(ColorTheme.background.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingAddWallet) {
            AddWalletView(viewModel: viewModel)
        }
    }
}

#Preview {
    CombinedBalanceView(viewModel: WalletViewModel())
}
