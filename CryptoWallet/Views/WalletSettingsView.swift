//
//  WalletSettingsView.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct WalletSettingsView: View {
    @ObservedObject var viewModel: WalletViewModel
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Wallets")) {
                    if viewModel.wallets.isEmpty {
                        Text("No wallets added yet")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(viewModel.wallets) { wallet in
                            WalletRow(wallet: wallet)
                        }
                        .onDelete(perform: viewModel.removeWallet)
                    }
                }
                
                Section {
                    Button("Add New Wallet") {
                        viewModel.isAddingWallet = true
                    }
                }
            }
            .navigationTitle("Wallet Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
        }
        .tabItem {
            Label("Settings", systemImage: "gear")
        }
    }
}

struct WalletRow: View {
    let wallet: Wallet

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(wallet.name)
                    .font(.headline)
                Text(wallet.address.prefix(6) + "..." + wallet.address.suffix(4))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    WalletSettingsView(viewModel: WalletViewModel())
}
