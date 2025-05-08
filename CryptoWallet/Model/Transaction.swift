import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    let walletAddress: String
    let tokenSymbol: String
    let tokenName: String
    let amount: Double
    let valueUSD: Double
    let timestamp: Date
    let type: TransactionType
    
    enum TransactionType: String, Codable {
        case receive
        case send
        case swap
    }
}

// TransactionHistoryView.swift - Create this new file
import SwiftUI

struct TransactionHistoryView: View {
    @ObservedObject var viewModel: WalletViewModel
    
    // Mock transactions for demo
    var transactions: [Transaction] {
        var mockTransactions: [Transaction] = []
        
        // Create mock transactions for each wallet
        for wallet in viewModel.wallets {
            for token in wallet.balances {
                // Add a receive transaction
                mockTransactions.append(
                    Transaction(
                        id: UUID(),
                        walletAddress: wallet.address,
                        tokenSymbol: token.symbol,
                        tokenName: token.name,
                        amount: token.balance * 0.5,
                        valueUSD: token.valueUSD * 0.5,
                        timestamp: Date().addingTimeInterval(-86400 * Double.random(in: 1...10)),
                        type: .receive
                    )
                )
                
                // Add a send transaction
                mockTransactions.append(
                    Transaction(
                        id: UUID(),
                        walletAddress: wallet.address,
                        tokenSymbol: token.symbol,
                        tokenName: token.name,
                        amount: token.balance * 0.2,
                        valueUSD: token.valueUSD * 0.2,
                        timestamp: Date().addingTimeInterval(-86400 * Double.random(in: 11...20)),
                        type: .send
                    )
                )
            }
        }
        
        return mockTransactions.sorted { $0.timestamp > $1.timestamp }
    }
    
    var groupedTransactions: [Date: [Transaction]] {
        let calendar = Calendar.current
        var result: [Date: [Transaction]] = [:]
        
        for transaction in transactions {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: transaction.timestamp)
            if let date = calendar.date(from: dateComponents) {
                if result[date] == nil {
                    result[date] = []
                }
                result[date]?.append(transaction)
            }
        }
        
        return result
    }
    
    var sortedDates: [Date] {
        groupedTransactions.keys.sorted(by: >)
    }
    
    var body: some View {
        List {
            ForEach(sortedDates, id: \.self) { date in
                Section(header: Text(dateFormatter.string(from: date))) {
                    ForEach(groupedTransactions[date] ?? []) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
        }
        .navigationTitle("Transaction History")
        .overlay {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "clock.arrow.circlepath",
                    description: Text("Your transaction history will appear here.")
                )
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            // Transaction type icon
            ZStack {
                Circle()
                    .fill(transactionColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: transactionIcon)
                    .foregroundColor(transactionColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.type.rawValue.capitalized)
                    .font(Typography.bodyBold)
                    .foregroundColor(ColorTheme.text)
                
                Text("\(transaction.tokenSymbol) • \(timeFormatter.string(from: transaction.timestamp))")
                    .font(Typography.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(transaction.type == .receive ? "+" : "-")\(transaction.amount, specifier: "%.4f") \(transaction.tokenSymbol)")
                    .font(Typography.bodyBold)
                    .foregroundColor(transactionColor)
                
                Text("\(transaction.valueUSD, specifier: "$%.2f")")
                    .font(Typography.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private var transactionIcon: String {
        switch transaction.type {
        case .receive:
            return "arrow.down"
        case .send:
            return "arrow.up"
        case .swap:
            return "arrow.2.squarepath"
        }
    }
    
    private var transactionColor: Color {
        switch transaction.type {
        case .receive:
            return ColorTheme.accent
        case .send:
            return ColorTheme.negative
        case .swap:
            return Color.blue
        }
    }
}
