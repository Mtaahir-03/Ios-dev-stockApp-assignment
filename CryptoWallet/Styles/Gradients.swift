//
//  Gradients.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import SwiftUICore

struct Gradients {
    static let strokeGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.957, green: 0.957, blue: 0.957),
            Color(red: 0.337, green: 0.337, blue: 0.337),
            Color(red: 0.576, green: 0.702, blue: 0.682)
        ]),
        startPoint: .top, endPoint: .bottom)

    static let fillGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.835, green: 0.847, blue: 0.847),
            Color(red: 0.506, green: 0.549, blue: 0.541)
        ]),
        startPoint: .top, endPoint: .bottom)

    static let imageGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.145, green: 0.141, blue: 0.141),
            Color(red: 0.235, green: 0.235, blue: 0.235)
        ]),
        startPoint: .top, endPoint: .bottom)
}

