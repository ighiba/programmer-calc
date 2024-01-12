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

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
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
    
    func testRemoveLeading() throws {
        // 1. given
        let stringWithSpaces = "0000000110001001"

        // 2. when
        let result = stringWithSpaces.removedLeading(characters: ["0"])
        
        // 3. then
        XCTAssertEqual(result, "110001001", "Failed removing")
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
