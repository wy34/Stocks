//
//  Date.swift
//  Stocks
//
//  Created by William Yeung on 8/1/21.
//

import Foundation

extension Date {
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toString(_ style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
}

