import SwiftUI

struct PriceAlertView: View {
    let token: TokenBalance
    @State private var alertPrice: String = ""
    @State private var alertType: AlertType = .above
    @State private var showingConfirmation = false
    
    enum AlertType: String, CaseIterable {
        case above = "Above"
        case below = "Below"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set Price Alert")) {
                    Picker("Alert Type", selection: $alertType) {
                        ForEach(AlertType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Current Price:")
                        Spacer()
                        Text("$\(token.price, specifier: "%.2f")")
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    HStack {
                        Text("Alert Price:")
                        
                        TextField("Enter price", text: $alertPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    Button("Set Alert") {
                        // Would save the alert in a real app
                        showingConfirmation = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(ColorTheme.accent)
                    .disabled(alertPrice.isEmpty)
                }
                
                Section(header: Text("How It Works")) {
                    Text("You will receive a notification when the price of \(token.symbol) goes \(alertType == .above ? "above" : "below") $\(alertPrice.isEmpty ? "0.00" : alertPrice).")
                        .font(Typography.footnote)
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            .navigationTitle("Price Alert")
            .alert("Alert Created", isPresented: $showingConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You will be notified when \(token.symbol) goes \(alertType == .above ? "above" : "below") $\(alertPrice).")
            }
        }
    }
}
