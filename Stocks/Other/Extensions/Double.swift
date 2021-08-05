//
//  Double.swift
//  Stocks
//
//  Created by William Yeung on 8/3/21.
//

import Foundation

extension Double {
    func formattedPercentString() -> String {
        return NumberFormatter.percentFormatter.string(from: .init(value: self)) ?? ""
    }
    
    func formattedNumberString() -> String {
        return NumberFormatter.numberFormatter.string(from: .init(value: self)) ?? ""
    }
    
    func roundToPlaces(_ place: Int) -> Double {
        let base = pow(10, Double(place))
        return floor(self * base) / base
    }
}
