//
//  CoinGeckoAPI.swift
//  CryptoWallet
//
//  Created by ウェルン on 10/5/2025.
//

import Foundation

class CoinGeckoAPI {
    private let apiKey = "V1Yd2vvsUJKKhnyb9YdkmZEn"
    private var coinsList: [CoinGeckoCoin]? = nil
    
    struct CoinGeckoCoin: Decodable {
        let id: String
        let symbol: String
        let name: String
    }

    struct MarketChartResponse: Decodable {
        let prices: [[Double]]
    }
    
    func getPriceHistory(for symbol: String, days: Int = 7) async throws -> [PriceData] {
        let coinID = try await fetchCoinID(for: symbol.lowercased())
        return try await fetchMarketChart(for: coinID, days: days)
    }
    
    // gets the Coin Gecko list of supported cryptocurrencies
    // used to map the symbol (used by moralis) to the id (used by Coin Gecko)
    private func fetchCoinID(for symbol: String) async throws -> String {
        if let cachedCoins = coinsList {
            if let match = cachedCoins.first(where: { $0.symbol.lowercased() == symbol.lowercased() }) {
                return match.id
            }
        }

        let url = URL(string: "https://api.coingecko.com/api/v3/coins/list")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let coins = try JSONDecoder().decode([CoinGeckoCoin].self, from: data)

        // cache coinList to reduce API calls
        coinsList = coins

        guard let match = coins.first(where: { $0.symbol.lowercased() == symbol.lowercased() }) else {
            throw NSError(domain: "CoinNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Coin symbol not found"])
        }

        return match.id
    }

    private func fetchMarketChart(for id: String, days: Int) async throws -> [PriceData] {
        let interval = (days == 7 || days == 30) ? "daily" : ""
        var urlComponents = URLComponents(string: "https://api.coingecko.com/api/v3/coins/\(id)/market_chart")!
        urlComponents.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "days", value: "\(days)"),
            URLQueryItem(name: "interval", value: interval)
        ]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let chartData = try JSONDecoder().decode(MarketChartResponse.self, from: data)

        let priceData = chartData.prices.compactMap { entry -> PriceData? in
            guard entry.count == 2 else { return nil }
            let timestamp = Date(timeIntervalSince1970: entry[0] / 1000)
            return PriceData(timestamp: timestamp, price: entry[1])
        }

        return priceData
    }
}
