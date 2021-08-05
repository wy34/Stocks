//
//  StocksTests.swift
//  StocksTests
//
//  Created by William Yeung on 8/5/21.
//

import XCTest
@testable import Stocks

class StocksTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCandleStickDataConversion() {
        let doubles = Array(repeating: 12.2, count: 10)
        
        var timestamp = [TimeInterval]()
        for x in 0..<12 {
            let interval = Date().addingTimeInterval(3600 * TimeInterval(x)).timeIntervalSince1970
            timestamp.append(interval)
        }
        timestamp.shuffle()
        
        let data =  MarketDataResponse(open: doubles, close: doubles, high: doubles, low: doubles, status: "success", timestamps: timestamp)
        
        let candleSticks = data.candleSticks
        
        XCTAssertEqual(candleSticks.count, data.open.count)
        XCTAssertEqual(candleSticks.count, data.close.count)
        XCTAssertEqual(candleSticks.count, data.high.count)
        XCTAssertEqual(candleSticks.count, data.low.count)
        
        // Testing dates sorted order
        let dates = candleSticks.map({ $0.date })
        for x in 0..<dates.count-1 {
            let current = dates[x]
            let next = dates[x+1]
            XCTAssertTrue(current >= next)
        }
    }
}
