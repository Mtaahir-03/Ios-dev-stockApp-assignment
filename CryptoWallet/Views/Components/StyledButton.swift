//
//  StyledButton.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUI

struct StyledButton: View {
    var iconName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Gradients.fillGradient)
                .offset(y: 35 * 0.3) // shift down so only 30% shows
                .opacity(0.5)
                .blur(radius: 7)
            
            Circle()
                .fill(Gradients.fillGradient)
                .stroke(Gradients.strokeGradient, lineWidth: 2)

            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16)
                .foregroundStyle(Gradients.imageGradient)
                .font(Font.title.weight(.black))
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
        }
        .fixedSize()
    }
}

#Preview {
    StyledButton(iconName: "arrow.clockwise")
}
