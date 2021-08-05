//
//  HapticsManager.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit

final class HapticsManager {
    // MARK: - Properties
    static let shared = HapticsManager()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Helpers
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
