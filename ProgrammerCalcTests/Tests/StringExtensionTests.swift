//
//  StringExtensionTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 30.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import XCTest
@testable import ProgrammerCalc

final class StringExtensionTests: XCTestCase {

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
        let testString = "0000 1111 0000 1111"

        // 2. when
        let result = testString.removedAllSpaces()
        
        // 3. then
        XCTAssertEqual(result, "0000111100001111", "Failed at removing spaces")
    }
    
    func testRemoveLeading() throws {
        // 1. given
        let testString = "0000000110001001"

        // 2. when
        let result = testString.removedLeading(characters: ["0"])
        
        // 3. then
        XCTAssertEqual(result, "110001001", "Failed removing")
    }
    
    func testGetComponentAfter() throws {
        // 1. given
        let testString = "10001001.10011111"

        // 2. when
        let result = testString.getComponent(.after, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "10011111", "Failed getting component")
    }
    
    func testGetComponentBefore() throws {
        // 1. given
        let testString = "10001001.10011111"

        // 2. when
        let result = testString.getComponent(.before, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "10001001", "Failed getting component")
    }
    
    func testGetComponentAfter_EMPTY() throws {
        // 1. given
        let testString = "0."

        // 2. when
        let result = testString.getComponent(.after, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "", "Failed getting component")
    }
    
    func testGetComponentBefore_EMPTY() throws {
        // 1. given
        let testString = "0."

        // 2. when
        let result = testString.getComponent(.before, separator: ".")
        
        // 3. then
        XCTAssertEqual(result, "0", "Failed getting component")
    }
}
