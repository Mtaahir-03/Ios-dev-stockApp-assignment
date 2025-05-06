//
//  AddWalletView.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct AddWalletView: View {
    @ObservedObject var viewModel: WalletViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Wallet Details")) {
                    TextField("Wallet Name", text: $viewModel.newWalletName)
                        .autocapitalization(.none)
                    
                    TextField("Wallet Address", text: $viewModel.newWalletAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section {
                    Button("Add Wallet") {
                        viewModel.addWallet()
                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                    .disabled(viewModel.newWalletName.isEmpty || viewModel.newWalletAddress.isEmpty)
                }
            }
            .navigationTitle("Add Wallet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
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
        }
    }
}

#Preview {
    AddWalletView(viewModel: WalletViewModel())
}
