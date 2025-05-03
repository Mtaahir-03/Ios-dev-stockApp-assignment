//
//  SettingsView.swift
//  CryptoWallet
//
//  Created by ウェルン on 3/5/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var darkMode = false
    @State private var selectedCurrency = "AUD"
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "AUD"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Account Details View")) {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                                .frame(width: 32, height: 32)
                            
                            VStack(alignment: .leading) {
                                Text("Alex Johnson")
                                    .font(.headline)
                                
                                Text("alex@example.com")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(header: Text("Security")) {
                    NavigationLink(destination: Text("Change Password View")) {
                        SettingsRow(icon: "lock", iconColor: .red, title: "Change Password")
                    }
                    
                    NavigationLink(destination: Text("Recovery Phrase View")) {
                        SettingsRow(icon: "key", iconColor: .red, title: "Recovery Phrase")
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Picker("Currency", selection: $selectedCurrency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Support")) {
                    NavigationLink(destination: Text("Contact Support View")) {
                        SettingsRow(icon: "envelope", iconColor: .blue, title: "Contact Support")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            Text(title)
                .padding(.leading, 8)
        }
    }
}

#Preview {
    SettingsView()
}
