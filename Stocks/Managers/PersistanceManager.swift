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
        
    }
    
    private let userDefaults: UserDefaults = .standard
    
    private var hasOnboard: Bool {
        return false
    }
    
    var watchList: [String] {
        return []
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Helpers
    func addToWatchList() {
        
    }
    
    func removeFromWatchList() {
        
    }
}
