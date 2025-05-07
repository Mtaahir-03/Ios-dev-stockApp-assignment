//
//  MoralisAPI.swift
//  CryptoWallet
//
//  Created by ウェルン on 6/5/2025.
//

import Foundation

let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6ImUwMWYwOGUyLTRmMzUtNGZlNy1hZGJhLTAwYzY3ZjlmNzJhYiIsIm9yZ0lkIjoiNDQ1MDMxIiwidXNlcklkIjoiNDU3ODgxIiwidHlwZUlkIjoiMTRhNjUwMTAtNzgxYy00MDc3LTk1NzEtMjEyMjk4ZDIzYWYxIiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3NDYyNTMxMzEsImV4cCI6NDkwMjAxMzEzMX0.AvOuOeUqyOt9XASxbfknamc0jRd-pz5ZLRih_d4qgoI"

class MoralisAPI {
    private let apiKey = key // Replace
    private let baseURL = "https://deep-index.moralis.io/api/v2.2"
    
    struct WalletTokensResponse: Decodable {
        let result: [WalletToken]
    }

    struct WalletToken: Decodable {
        let token_address: String
        let symbol: String
        let name: String
        let decimals: Int
        let balance: String
        let usd_price: Double?
    }

    func getTokenBalances(for address: String) async throws -> [TokenBalance] {
        guard let url = URL(string: "\(baseURL)/wallets/\(address)/tokens?chain=eth") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(WalletTokensResponse.self, from: data)

        return decoded.result.compactMap { token in
            guard let rawBalance = Double(token.balance) else { return nil }
            let adjustedBalance = rawBalance / pow(10.0, Double(token.decimals))

            return TokenBalance(
                symbol: token.symbol,
                name: token.name,
                balance: adjustedBalance,
                decimals: token.decimals,
                tokenAddress: token.token_address,
                price: token.usd_price ?? 0
            )
        }
    }
    
    func getTokenPrice(address: String) async throws -> Double {
        guard let url = URL(string: "\(baseURL)/erc20/\(address)/price?chain=eth") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct PriceResponse: Decodable {
            let usdPrice: Double
        }
        
        let response = try JSONDecoder().decode(PriceResponse.self, from: data)
        return response.usdPrice
    }
    
    func getPriceHistory(for symbol: String, days: Int = 7) async throws -> [PriceData] {
        // DEMO NEED TO USE Moralis API to get historical price data
        // placeholder that returns mock data for example
        
        let now = Date()
        let calendar = Calendar.current
        
        var priceData: [PriceData] = []
        
        // generate some random price data for the last 7 days
        for day in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -day, to: now) else {
                continue
            }
            
            // random price fluctuation around $2000 for example
            let randomPrice = 2000.0 + Double.random(in: -200...200)
            
            priceData.append(PriceData(
                timestamp: date,
                price: randomPrice
            ))
        }
        
        return priceData.reversed()
    }
}
