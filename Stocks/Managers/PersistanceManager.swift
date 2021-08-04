//
//  PersistanceManager.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import Foundation

final class PersistanceManager {
    // MARK: - Properties
    static let shared = PersistanceManager()
    
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchlistKey = "watchlist"
    }
    
    private let userDefaults: UserDefaults = .standard
    
    private var hasOnboard: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    var watchList: [String] {
        if !hasOnboard {
            userDefaults.setValue(true, forKey: Constants.onboardedKey)
            setupDefaults()
        }
        
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Helpers
    func addToWatchList() {
        
    }
    
    func removeFromWatchList(symbol: String) {
        var currentSymbols = watchList
        
        if let index = currentSymbols.firstIndex(of: symbol) {
            currentSymbols.remove(at: index)
            userDefaults.setValue(currentSymbols, forKey: Constants.watchlistKey)
        }
        
        userDefaults.removeObject(forKey: symbol)
    }
    
    private func setupDefaults() {
        let map = [
            "AAPL": "Apple Inc",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com, Inc",
            "NKE": "Nike",
            "NVDA": "Nvidia Inc"
        ]
        
        let symbols = map.keys.map({ $0 })
        userDefaults.setValue(symbols, forKey: Constants.watchlistKey)
        
        for (symbol, name) in map {
            userDefaults.setValue(name, forKey: symbol)
        }
    }
}

// ["AAPL", "MSFT", ...]
//  "AAPL": "Apple Inc", "MSFT": "Microsoft Corporation",
