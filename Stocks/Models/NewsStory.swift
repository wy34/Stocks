//
//  NewsStory.swift
//  Stocks
//
//  Created by William Yeung on 8/1/21.
//

import Foundation

struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let id: Int
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
