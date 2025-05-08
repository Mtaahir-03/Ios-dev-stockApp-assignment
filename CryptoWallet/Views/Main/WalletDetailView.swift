import SwiftUI

struct WalletDetailView: View {
    let wallet: Wallet
    @State private var showingAddressSheet = false
    @State private var showingCopiedToast = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Wallet header
                CardView {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Wallet")
                                    .font(Typography.footnote)
                                    .foregroundColor(ColorTheme.secondaryText)
                                
                                Text(wallet.name)
                                    .font(Typography.title3)
                                    .foregroundColor(ColorTheme.text)
                            }
                            
                            Spacer()
                            
                            Circle()
                                .fill(ColorTheme.accent.opacity(0.2))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: "wallet.pass.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(ColorTheme.accent)
                                )
                        }
                        
                        Divider()
                        
                        Button {
                            showingAddressSheet = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Address")
                                        .font(Typography.footnote)
                                        .foregroundColor(ColorTheme.secondaryText)
                                    
                                    Text(wallet.address.prefix(8) + "..." + wallet.address.suffix(8))
                                        .font(Typography.body)
                                        .foregroundColor(ColorTheme.text)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(ColorTheme.accent)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Value")
                                .font(Typography.footnote)
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            Text(String(format: "$%.2f", wallet.totalValueUSD))
                                .font(Typography.money)
                                .foregroundColor(ColorTheme.text)
                        }
                    }
                }
                
                // Tokens section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tokens")
                        .font(Typography.title3)
                        .foregroundColor(ColorTheme.text)
                        .padding(.horizontal)
                    
                    if wallet.balances.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "bitcoinsign.circle")
                                .font(.system(size: 48))
                                .foregroundColor(ColorTheme.secondaryText)
                                .padding()
                            
                            Text("No tokens found")
                                .font(Typography.body)
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            Text("Tokens will appear here once detected")
                                .font(Typography.caption)
                                .foregroundColor(ColorTheme.tertiaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                    } else {
                        ForEach(wallet.balances) { token in
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
                                            Text(token.formattedBalance)
                                                .font(Typography.body)
                                                .foregroundColor(ColorTheme.text)
                                            
                                            Text(token.formattedValueUSD)
                                                .font(Typography.bodyBold)
                                                .foregroundColor(ColorTheme.secondaryText)
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
            .padding(.vertical)
        }
        .background(ColorTheme.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(wallet.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddressSheet) {
            NavigationView {
                VStack(spacing: 30) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 150))
                        .foregroundColor(ColorTheme.accent)
                        .padding()
                    
                    VStack(spacing: 8) {
                        Text("Wallet Address")
                            .font(Typography.title3)
                            .foregroundColor(ColorTheme.text)
                        
                        Text(wallet.address)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(ColorTheme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
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
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showingAddressSheet = false
                        }
                        .foregroundColor(ColorTheme.accent)
                    }
                }
            }
        }
        .overlay(
            Group {
                if showingCopiedToast {
                    VStack {
                        Spacer()
                        
                        Text("Address copied!")
                            .padding(12)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom, 20)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: showingCopiedToast)
                }
            }
        )
    }
}
