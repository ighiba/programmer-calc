//
//  StringExtTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 30.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import XCTest
@testable import ProgrammerCalc

class StringExtTests: XCTestCase {

    var stringExtTest: String!

    override func setUp() {
        super.setUp()
        stringExtTest = String()
    }
    
    override func tearDown() {
        stringExtTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRadixDecimal() throws {
        // 1. given
        let decimalValue: Decimal = 123

        // 2. when
        let result = String(decimalValue, radix: 2)
        
        // 3. then
        XCTAssertEqual(result, "1111011", "Radix failure")
    }
    
    func testRemoveAllSpaces() throws {
        // 1. given
        let stringWithSpaces = "0000 1111 0000 1111"

        // 2. when
        let result = stringWithSpaces.removedAllSpaces()
        
        // 3. then
        XCTAssertEqual(result, "0000111100001111", "Failed at removing spaces")
    }
    
    func testSwap() throws {
        // 1. given
        let stringWithSpaces = "1000 1001"

        // 2. when
        let result = stringWithSpaces.swap(first: "1", second: "0")
        
        // 3. then
        XCTAssertEqual(result, "0111 0110", "Failed swapping")
    }
    
    func testRemoveLeading() throws {
        // 1. given
        let stringWithSpaces = "0000000110001001"

        // 2. when
        let result = stringWithSpaces.removedLeading(characters: ["0"])
        
        // 3. then
        XCTAssertEqual(result, "110001001", "Failed removing")
    }
    func testRemoveTrailing() throws {
        // 1. given
        let stringWithSpaces = "1000 1001.1001 1000"

        // 2. when
        let result = stringWithSpaces.removedTrailing(characters: ["0"])
        
        // 3. then
        XCTAssertEqual(result, "10001001.10011", "Failed removing")
    }
    
    func testGetPartAfter() throws {
        // 1. given
        let stringWithSpaces = "10001001.10011111"

        // 2. when
        let result = stringWithSpaces.getPart(.after, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "10011111", "Failed getting part")
    }
    
    func testGetPartBefore() throws {
        // 1. given
        let stringWithSpaces = "10001001.10011111"

        // 2. when
        let result = stringWithSpaces.getPart(.before, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "10001001", "Failed getting part")
    }
    
    func testGetPartAfter_EMPTY() throws {
        // 1. given
        let stringWithSpaces = "0."

        // 2. when
        let result = stringWithSpaces.getPart(.after, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "", "Failed getting part")
    }
    
    func testGetPartBefore_EMPTY() throws {
        // 1. given
        let stringWithSpaces = "0."

        // 2. when
        let result = stringWithSpaces.getPart(.before, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "0", "Failed getting part")
    }

}
