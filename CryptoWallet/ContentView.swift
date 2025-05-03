//
//  ContentView.swift
//  CryptoWallet
//
//  Created by ウェルン on 3/5/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WalletView()
                .tabItem {
                    Label("Wallet", systemImage: "creditcard")
                }
            
            ExchangeView()
                .tabItem {
                    Label("Exchange", systemImage: "arrow.left.arrow.right")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(.blue)
    }
}


#Preview {
    ContentView()
}
