//
//  CombinedBalanceView.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct CombinedBalanceView: View {
    @ObservedObject var viewModel: WalletViewModel
    @State private var showingAddWallet = false
    
    var body: some View {
        VStack {
            if viewModel.wallets.isEmpty {
                VStack(spacing: 20) {
                    Text("No wallets added yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Button("Add Your First Wallet") {
                        showingAddWallet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                ScrollView {
                    VStack {
                        Text("Total Portfolio Value")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.formattedTotalBalanceUSD)
                            .font(.system(size: 42, weight: .bold))
                            .padding(.bottom)
                        
                        ForEach(viewModel.wallets) { wallet in
                            NavigationLink(destination: WalletDetailView(wallet: wallet)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(wallet.name)
                                            .font(.headline)
                                        
                                        Text(wallet.address.prefix(6) + "..." + wallet.address.suffix(4))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(String(format: "$%.2f", wallet.totalValueUSD))
                                        .bold()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingAddWallet) {
            AddWalletView(viewModel: viewModel)
        }
    }
}

#Preview {
    CombinedBalanceView(viewModel: WalletViewModel())
}
