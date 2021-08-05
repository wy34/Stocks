//
//  CandleStick.swift
//  Stocks
//
//  Created by William Yeung on 8/5/21.
//

import Foundation

// An extension on arrays where the items are only CandleStick
extension Array where Element == CandleStick {
    func getChangePercentage() -> Double {
        let latestDate = self[0].date
        
        guard let latestClose = self.first?.close,
              let priorClose = self.first(where: { !Calendar.current.isDate($0.date, inSameDayAs: latestDate) })?.close else {
            return 0
        }
        
        return 1 - (priorClose / latestClose)
    }
}
