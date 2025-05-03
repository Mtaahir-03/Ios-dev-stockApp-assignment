//
//  ExchangeView.swift
//  CryptoWallet
//
//  Created by ウェルン on 3/5/2025.
//

import SwiftUI

struct ExchangeView: View {
    @State private var fromCrypto = "BTC"
    @State private var toCrypto = "ETH"
    @State private var amount = ""
    
    let cryptoOptions = ["BTC", "ETH", "ADA", "SOL", "DOT"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Exchange card
                VStack(spacing: 20) {
                    // From section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("From")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            TextField("0.0", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 24, weight: .medium))
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            Picker("From", selection: $fromCrypto) {
                                ForEach(cryptoOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .frame(width: 100)
                        }
                    }
                    
                    // Swap button
                    Button(action: {
                        let temp = fromCrypto
                        fromCrypto = toCrypto
                        toCrypto = temp
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 20, weight: .bold))
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                    
                    // To section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("To")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text(amount.isEmpty ? "0.0" : amount)
                                .font(.system(size: 24, weight: .medium))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            Picker("To", selection: $toCrypto) {
                                ForEach(cryptoOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .frame(width: 100)
                        }
                    }
                    
                    // Exchange rate info
                    HStack {
                        Text("1 \(fromCrypto) ≈ 16.7 \(toCrypto)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Updated 1m ago")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
                .padding(.horizontal)
                
                Spacer()
                
                // Exchange button
                Button(action: {
                    // Handle exchange action
                }) {
                    Text("Exchange")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(amount.isEmpty ? Color.blue.opacity(0.5) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(amount.isEmpty)
                .padding()
            }
            .navigationTitle("Exchange")
        }
    }
}

#Preview {
    ExchangeView()
}
