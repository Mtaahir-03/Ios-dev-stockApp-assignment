import SwiftUI

struct WalletCarousel: View {
    let wallets: [Wallet]
    @Binding var selectedWalletIndex: Int
    
    var body: some View {
        VStack {
            TabView(selection: $selectedWalletIndex) {
                ForEach(wallets.indices, id: \.self) { index in
                    WalletCard(wallet: wallets[index])
                        .padding(.horizontal)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 200)
            
            // Wallet pagination indicators
            HStack(spacing: 8) {
                ForEach(wallets.indices, id: \.self) { index in
                    Circle()
                        .fill(index == selectedWalletIndex ? ColorTheme.accent : ColorTheme.secondaryText.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.spring(), value: selectedWalletIndex)
                }
            }
            .padding(.vertical)
        }
    }
}

struct WalletCard: View {
    let wallet: Wallet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(wallet.name)
                        .font(Typography.title3)
                        .foregroundColor(.white)
                    
                    Text(wallet.address.prefix(6) + "..." + wallet.address.suffix(4))
                        .font(Typography.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Balance")
                    .font(Typography.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(String(format: "$%.2f", wallet.totalValueUSD))
                    .font(Typography.moneyLarge)
                    .foregroundColor(.white)
            }
            
            Text("\(wallet.balances.count) Tokens")
                .font(Typography.footnote)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: 180)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 0.4),
                    Color(red: 0.1, green: 0.4, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: ColorTheme.cardShadow, radius: 10, x: 0, y: 5)
    }
}
