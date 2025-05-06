//
//  ContentView.swift
//  CryptoWallet
//
//  Created by ウェルン on 3/5/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WalletViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                CombinedBalanceView(viewModel: viewModel)
                    .navigationTitle("My Wallets")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                Task {
                                    await viewModel.fetchAllWalletBalances()
                                }
                            }) {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                viewModel.isAddingWallet = true
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
            }
            .tabItem {
                Label("Wallets", systemImage: "wallet.pass")
            }
            
            NavigationView {
                MarketView(viewModel: viewModel)
            }
            .tabItem {
                Label("Market", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            WalletSettingsView(viewModel: viewModel)
        }
        .onAppear {
            // fetch wallet balances when the app launches
            if !viewModel.wallets.isEmpty {
                Task {
                    await viewModel.fetchAllWalletBalances()
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddingWallet) {
            AddWalletView(viewModel: viewModel)
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


#Preview {
    ContentView()
}
