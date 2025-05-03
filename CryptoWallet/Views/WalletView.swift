//
//  WalletView.swift
//  CryptoWallet
//
//  Created by ウェルン on 3/5/2025.
//

import SwiftUI

struct WalletView: View {
    // Sample wallet data
    let cryptocurrencies = [
        Cryptocurrency(name: "Bitcoin", symbol: "BTC", balance: 0.25, value: 15000.00),
        Cryptocurrency(name: "Ethereum", symbol: "ETH", balance: 3.5, value: 8500.00),
        Cryptocurrency(name: "Cardano", symbol: "ADA", balance: 450.0, value: 675.00)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Total balance section
                VStack(spacing: 8) {
                    Text("Total Balance")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("$\(getTotalValue(), specifier: "%.2f")")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .padding(.horizontal)
                
                // List of cryptocurrencies
                List {
                    ForEach(cryptocurrencies) { crypto in
                        HStack {
                            // Crypto icon (placeholder)
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Text(crypto.symbol.prefix(1))
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            
                            // Crypto details
                            VStack(alignment: .leading, spacing: 4) {
                                Text(crypto.name)
                                    .font(.headline)
                                
                                Text("\(crypto.balance, specifier: "%.4f") \(crypto.symbol)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Value
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("$\(crypto.value, specifier: "%.2f")")
                                    .font(.headline)
                                
                                Text("$\(crypto.value / crypto.balance, specifier: "%.2f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                // Send and Receive buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Handle Send action
                    }) {
                        HStack {
                            Image(systemName: "arrow.up")
                            Text("Send")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Handle Receive action
                    }) {
                        HStack {
                            Image(systemName: "arrow.down")
                            Text("Receive")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Wallet")
        }
    }
    
    func getTotalValue() -> Double {
        return cryptocurrencies.reduce(0) { $0 + $1.value }
    }
}

#Preview {
    WalletView()
}
