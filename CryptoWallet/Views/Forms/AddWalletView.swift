import SwiftUI

struct AddWalletView: View {
    @ObservedObject var viewModel: WalletViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, address
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 60))
                    .foregroundColor(ColorTheme.accent)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wallet Name")
                        .font(Typography.footnote)
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    TextField("", text: $viewModel.newWalletName)
                        .font(Typography.body)
                        .padding()
                        .background(ColorTheme.secondaryBackground)
                        .cornerRadius(12)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .address
                        }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wallet Address")
                        .font(Typography.footnote)
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    TextField("", text: $viewModel.newWalletAddress)
                        .font(Typography.body)
                        .padding()
                        .background(ColorTheme.secondaryBackground)
                        .cornerRadius(12)
                        .focused($focusedField, equals: .address)
                        .submitLabel(.done)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            if !viewModel.newWalletName.isEmpty && !viewModel.newWalletAddress.isEmpty {
                                viewModel.addWallet()
                                if viewModel.errorMessage == nil {
                                    dismiss()
                                }
                            }
                        }
                }
                
                Spacer()
                
                Button("Add Wallet") {
                    viewModel.addWallet()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
                .buttonStyle(AddWalletButtonStyle())
                .disabled(viewModel.newWalletName.isEmpty || viewModel.newWalletAddress.isEmpty)
                .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle("Add Wallet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accent)
                }
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focusedField = .name
                }
            }
        }
    }
}
