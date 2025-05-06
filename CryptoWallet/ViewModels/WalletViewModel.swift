//
//  WalletViewModel.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import Foundation
import Combine

class WalletViewModel: ObservableObject {
    @Published var wallets: [Wallet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAddingWallet = false
    @Published var newWalletName = ""
    @Published var newWalletAddress = ""
    
    private let moralisAPI = MoralisAPI()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadWallets()
        
        // should be if no saved wallets, initialise with empty list, but added this random address for testing
        if wallets.isEmpty {
            //  random wallet i found online for demo purposes
            wallets = [Wallet(address: "0x00000000000000C0D7D3017B342ff039B55b0879", name: "Test Wallet")]
        }
    }
    
    private func loadWallets() {
        if let savedWallets = UserDefaults.standard.data(forKey: "savedWallets") {
            do {
                let decoder = JSONDecoder()
                let decodedWallets = try decoder.decode([SavedWallet].self, from: savedWallets)
                wallets = decodedWallets.map { Wallet(address: $0.address, name: $0.name) }
            } catch {
                print("Failed to load wallets: \(error)")
                wallets = []
            }
        }
    }
    
    func saveWallets() {
        do {
            let savedWallets = wallets.map { SavedWallet(address: $0.address, name: $0.name) }
            let encoder = JSONEncoder()
            let data = try encoder.encode(savedWallets)
            UserDefaults.standard.set(data, forKey: "savedWallets")
        } catch {
            print("Failed to save wallets: \(error)")
        }
    }
    
    func addWallet() {
        guard !newWalletAddress.isEmpty, !newWalletName.isEmpty else { return }
        
        // check for reasonable address length and format
        if !isValidEthereumAddress(newWalletAddress) {
            errorMessage = "Please enter a valid Ethereum address"
            return
        }
        
        let wallet = Wallet(address: newWalletAddress, name: newWalletName)
        wallets.append(wallet)
        
        // save to UserDefaults
        saveWallets()
        
        // reset form
        newWalletName = ""
        newWalletAddress = ""
        isAddingWallet = false
    }
    
    func removeWallet(at indexSet: IndexSet) {
        wallets.remove(atOffsets: indexSet)
        saveWallets()
    }
    
    private func isValidEthereumAddress(_ address: String) -> Bool {
        // simple regex validation - should start with 0x and be 42 characters long
        let addressRegex = "^0x[a-fA-F0-9]{40}$"
        let addressPredicate = NSPredicate(format: "SELF MATCHES %@", addressRegex)
        return addressPredicate.evaluate(with: address)
    }
    
    var totalBalanceUSD: Double {
        wallets.reduce(0) { $0 + $1.totalValueUSD }
    }
    
    var formattedTotalBalanceUSD: String {
        String(format: "USD $%.2f", totalBalanceUSD)
    }
    
    func fetchAllWalletBalances() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            for i in 0..<wallets.count {
                let balances = try await moralisAPI.getTokenBalances(for: wallets[i].address)
                
                await MainActor.run {
                    wallets[i].balances = balances
                }
            }
            
            await MainActor.run {
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to fetch wallet data: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
