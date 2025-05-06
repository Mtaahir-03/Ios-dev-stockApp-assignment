//
//  WalletDetailView.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct WalletDetailView: View {
    let wallet: Wallet
    @State private var showingAddressSheet = false
    @State private var showingCopiedToast = false
    
    var body: some View {
        List {
            Section(header: Text("Wallet Info")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(wallet.name)
                        .foregroundColor(.secondary)
                }
                
                Button {
                    showingAddressSheet = true
                } label: {
                    HStack {
                        Text("Address")
                        Spacer()
                        HStack {
                            Text(wallet.address.prefix(6) + "..." + wallet.address.suffix(4))
                                .foregroundColor(.secondary)
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
                    }
                }
                .overlay(
                    Group {
                        if showingCopiedToast {
                            VStack {
                                Spacer()
                                Text("Address copied!")
                                    .padding(8)
                                    .background(Color.black.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    },
                    alignment: .bottom
                )
                
                HStack {
                    Text("Total Value")
                    Spacer()
                    Text(String(format: "$%.2f", wallet.totalValueUSD))
                        .bold()
                }
            }
            
            Section(header: Text("Tokens")) {
                if wallet.balances.isEmpty {
                    Text("No tokens found")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(wallet.balances) { token in
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
                                    Text(token.formattedBalance)
                                    Text(token.formattedValueUSD)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(wallet.name)
        .sheet(isPresented: $showingAddressSheet) {
            NavigationView {
                VStack {
                    Text("Wallet Address")
                        .font(.headline)
                        .padding()
                    
                    Text(wallet.address)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Button {
                        UIPasteboard.general.string = wallet.address
                        showingCopiedToast = true
                        showingAddressSheet = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showingCopiedToast = false
                        }
                    } label: {
                        Label("Copy Address", systemImage: "doc.on.doc")
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showingAddressSheet = false
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    WalletDetailView(wallet: Wallet(address: "test address", name: "test wallet", balances: []))
}
