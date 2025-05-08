import SwiftUI

struct WalletSettingsView: View {
    @ObservedObject var viewModel: WalletViewModel
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App logo/icon
                    VStack(spacing: 8) {
                        Image(systemName: "wallet.pass.fill")
                            .font(.system(size: 64))
                            .foregroundColor(ColorTheme.accent)
                        
                        Text("Crypto Wallet")
                            .font(Typography.title)
                            .foregroundColor(ColorTheme.text)
                        
                        Text("v1.0")
                            .font(Typography.caption)
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    // Wallets section
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Wallets")
                                .font(Typography.title3)
                                .foregroundColor(ColorTheme.text)
                            
                            if viewModel.wallets.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("No wallets added yet")
                                        .font(Typography.body)
                                        .foregroundColor(ColorTheme.secondaryText)
                                        .padding()
                                    Spacer()
                                }
                            } else {
                                ForEach(viewModel.wallets) { wallet in
                                    VStack(spacing: 0) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(wallet.name)
                                                    .font(Typography.bodyBold)
                                                    .foregroundColor(ColorTheme.text)
                                                
                                                Text(wallet.address.prefix(6) + "..." + wallet.address.suffix(4))
                                                    .font(Typography.caption)
                                                    .foregroundColor(ColorTheme.secondaryText)
                                            }
                                            
                                            Spacer()
                                            
                                            if editMode == .active {
                                                Button {
                                                    if let index = viewModel.wallets.firstIndex(where: { $0.id == wallet.id }) {
                                                        viewModel.removeWallet(at: IndexSet(integer: index))
                                                    }
                                                } label: {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(ColorTheme.negative)
                                                }
                                            }
                                        }
                                        .padding(.vertical, 12)
                                        
                                        if wallet.id != viewModel.wallets.last?.id {
                                            Divider()
                                        }
                                    }
                                }
                            }
                            
                            Button {
                                viewModel.isAddingWallet = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Label("Add New Wallet", systemImage: "plus.circle.fill")
                                        .foregroundColor(ColorTheme.accent)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .background(ColorTheme.accent.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Options section
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Options")
                                .font(Typography.title3)
                                .foregroundColor(ColorTheme.text)
                            
                            Button {
                                withAnimation {
                                    editMode = editMode == .inactive ? .active : .inactive
                                }
                            } label: {
                                SettingsRow(
                                    iconName: editMode == .inactive ? "pencil.circle.fill" : "checkmark.circle.fill",
                                    title: editMode == .inactive ? "Edit Wallets" : "Done Editing",
                                    iconColor: ColorTheme.accent
                                )
                            }
                            
                            Divider()
                            
                            Button {
                                // Would sync data in a real app
                            } label: {
                                SettingsRow(
                                    iconName: "arrow.triangle.2.circlepath.circle.fill",
                                    title: "Sync Data",
                                    iconColor: ColorTheme.accent
                                )
                            }
                            
                            Divider()
                            
                            Button {
                                // Would open help/support in a real app
                            } label: {
                                SettingsRow(
                                    iconName: "questionmark.circle.fill",
                                    title: "Help & Support",
                                    iconColor: ColorTheme.accent
                                )
                            }
                        }
                    }
                    
                    // About section
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(Typography.title3)
                                .foregroundColor(ColorTheme.text)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Created for iOS Development Course")
                                    .font(Typography.body)
                                    .foregroundColor(ColorTheme.text)
                                
                                Text("This app demonstrates the use of SwiftUI, Combine, and URLSession to create a cryptocurrency wallet tracker.")
                                    .font(Typography.caption)
                                    .foregroundColor(ColorTheme.secondaryText)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.bottom, 8)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(ColorTheme.background.edgesIgnoringSafeArea(.all))
        }
    }
}

struct SettingsRow: View {
    let iconName: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .font(.system(size: 22))
                .frame(width: 36, height: 36)
            
            Text(title)
                .font(Typography.body)
                .foregroundColor(ColorTheme.text)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(ColorTheme.tertiaryText)
        }
    }
}
