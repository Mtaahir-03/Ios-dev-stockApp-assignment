import SwiftUI

struct CurrencySelector: View {
    @Binding var selectedCurrency: Currency
    @Environment(\.dismiss) private var dismiss
    
    enum Currency: String, CaseIterable, Identifiable {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        case jpy = "JPY"
        case aud = "AUD"
        
        var id: String { self.rawValue }
        
        var symbol: String {
            switch self {
            case .usd: return "$"
            case .eur: return "€"
            case .gbp: return "£"
            case .jpy: return "¥"
            case .aud: return "A$"
            }
        }
        
        var name: String {
            switch self {
            case .usd: return "US Dollar"
            case .eur: return "Euro"
            case .gbp: return "British Pound"
            case .jpy: return "Japanese Yen"
            case .aud: return "Australian Dollar"
            }
        }
        
        // Mock exchange rates for demo
        var exchangeRate: Double {
            switch self {
            case .usd: return 1.0
            case .eur: return 0.92
            case .gbp: return 0.78
            case .jpy: return 150.65
            case .aud: return 1.53
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Currency.allCases) { currency in
                    Button {
                        selectedCurrency = currency
                        dismiss()
                    } label: {
                        HStack {
                            Text("\(currency.symbol) \(currency.rawValue)")
                                .font(Typography.body)
                                .foregroundColor(ColorTheme.text)
                            
                            Spacer()
                            
                            Text(currency.name)
                                .font(Typography.caption)
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            if currency == selectedCurrency {
                                Image(systemName: "checkmark")
                                    .foregroundColor(ColorTheme.accent)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Currency")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
