//
//  StyledTextButton.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct StyledTextButton: View {
    var title: String
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Gradients.fillGradient)
        
                    .offset(y: 35 * 0.3)
                    .opacity(0.5)
                    .blur(radius: 7)
                
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Gradients.fillGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Gradients.strokeGradient, lineWidth: 4)
                    )
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Gradients.imageGradient)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
            }
            .fixedSize()
        }
}

#Preview {
    StyledTextButton(title: "Add Wallet")
}
