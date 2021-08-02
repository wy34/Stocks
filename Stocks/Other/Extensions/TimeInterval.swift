//
//  TimeInterval.swift
//  Stocks
//
//  Created by William Yeung on 8/2/21.
//

import Foundation

extension TimeInterval {
    func toDateString() -> String {
        let date = Date(timeIntervalSince1970: self)
        return date.toString(.medium)
    }
}
