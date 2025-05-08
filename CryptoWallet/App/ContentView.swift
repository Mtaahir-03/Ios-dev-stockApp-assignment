//
//  ContentView.swift
//  CryptoWallet
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WalletViewModel()
    @State private var showSplash = true
    @State private var selectedTab = 0
    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        ZStack {
            if showSplash {
                // SplashScreen
                VStack(spacing: 20) {
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 80))
                        .foregroundColor(ColorTheme.accent)
                    
                    Text("Crypto Wallet")
                        .font(Typography.title)
                        .foregroundColor(ColorTheme.text)
                }
                .scaleEffect(showSplash ? 1.0 : 0.8)
                .opacity(showSplash ? 1.0 : 0.0)
                .onAppear {
                    // Auto-dismiss splash after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
            } else {
                // Main app content
                VStack(spacing: 0) {
                    // Tab content area
                    TabView(selection: $selectedTab) {
                        // Tab 1: Wallets
                        NavigationView {
                            CombinedBalanceView(viewModel: viewModel)
                                .navigationTitle("Wallets")
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            Task {
                                                await viewModel.fetchAllWalletBalances()
                                            }
                                        }) {
                                            StyledButton(iconName: "arrow.clockwise")
                                        }
                                    }

                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            viewModel.isAddingWallet = true
                                        }) {
                                            StyledButton(iconName: "plus")
                                        }
                                    }
                                }
                                .overlay {
                                    if viewModel.isLoading {
                                        ZStack {
                                            Color.black.opacity(0.3)
                                                .edgesIgnoringSafeArea(.all)
                                            
                                            ProgressView()
                                                .scaleEffect(1.5)
                                                .padding()
                                                .background(ColorTheme.cardBackground)
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                        }
                        .tabItem {
                            Label("Wallets", systemImage: "wallet.pass")
                        }
                        .tag(0)

                        // Tab 2: Market
                        NavigationView {
                            MarketView(viewModel: viewModel)
                        }
                        .tabItem {
                            Label("Market", systemImage: "chart.line.uptrend.xyaxis")
                        }
                        .tag(1)

                        // Tab 3: Database
                        NavigationView {
                            TokenDatabaseView(viewModel: viewModel)
                        }
                        .tabItem {
                            Label("Database", systemImage: "list.bullet.rectangle")
                        }
                        .tag(2)

                        // Tab 4: Settings
                        NavigationView {
                            WalletSettingsView(viewModel: viewModel)
                        }
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(3)
                    }
                    
                    // Alternative: Use your custom tab bar instead of SwiftUI's built-in TabView
                    // CustomTabBar(selectedTab: $selectedTab, tabItems: [
                    //     .init(icon: "wallet.pass", selectedIcon: "wallet.pass.fill", title: "Wallets"),
                    //     .init(icon: "chart.line.uptrend.xyaxis", selectedIcon: "chart.line.uptrend.xyaxis.circle.fill", title: "Market"),
                    //     .init(icon: "list.bullet.rectangle", selectedIcon: "list.bullet.rectangle.fill", title: "Database"),
                    //     .init(icon: "gear", selectedIcon: "gear.circle.fill", title: "Settings")
                    // ])
                }
                .accentColor(ColorTheme.accent)
                
                // Error toast
                if viewModel.errorMessage != nil {
                    ToastView(
                        message: viewModel.errorMessage ?? "Unknown error",
                        icon: "exclamationmark.triangle",
                        showToast: Binding<Bool>(
                            get: { viewModel.errorMessage != nil },
                            set: { if !$0 { viewModel.errorMessage = nil } }
                        ).wrappedValue
                    )
                }
            }
        }
        .onAppear {
            // Fetch wallet balances when the app launches
            if !viewModel.wallets.isEmpty {
                Task {
                    await viewModel.fetchAllWalletBalances()
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddingWallet) {
            AddWalletView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
