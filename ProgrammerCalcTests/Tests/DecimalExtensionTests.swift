//
//  DecimalExtensionTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 18.01.2024.
//  Copyright © 2024 ighiba. All rights reserved.
//

import XCTest
@testable import ProgrammerCalc

final class DecimalExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIntPart() throws {
        let decimal = Decimal(string: "123.567")!

        let result = decimal.intPart
        
        XCTAssertEqual(result, 123, "Incorrect intPart")
    }
    
    func testFloatPart() throws {
        let decimal = Decimal(string: "123.567")!

        let result = decimal.floatPart
        
        XCTAssertEqual(result, 0.567, "Incorrect floatPart")
    }
    
    func testRoundedPartiallyDown() throws {
        let decimal = Decimal(string: "123.567")!

        let result = decimal.rounded(scale: 1, roundingMode: .down)
        
        XCTAssertEqual(result, 123.5, "Rounding failure")
    }
    
    func testRoundedPartiallyUp() throws {
        let decimal = Decimal(string: "123.567")!

        let result = decimal.rounded(scale: 1, roundingMode: .up)
        
        XCTAssertEqual(result, 123.6, "Rounding failure")
    }
    
    func testRoundedFullDown() throws {
        let decimal = Decimal(string: "123.567")!

        let result = decimal.rounded(.down)
        
        XCTAssertEqual(result, 123, "Rounding failure")
    }
    
    func testRoundedFullUp() throws {
        let decimal = Decimal(string: "123.567")!

        let result = decimal.rounded(.up)
        
        XCTAssertEqual(result, 124, "Rounding failure")
    }
    
    func testModuloOperatorOdd() throws {
        let lhs: Decimal = 144
        let rhs: Decimal = 2
        
        let result = lhs % rhs
        
        XCTAssertEqual(result, 0, "Modulo failure")
    }
    
    func testModuloOperatorEven() throws {
        let lhs: Decimal = 123
        let rhs: Decimal = 2
        
        let result = lhs % rhs
        
        XCTAssertEqual(result, 1, "Modulo failure")
    }
}
