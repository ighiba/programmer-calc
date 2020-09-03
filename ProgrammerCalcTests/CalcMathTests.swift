//
//  CalcMathTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 03.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class CalcMathTests: XCTestCase {
    
    var calcMathTest: CalcMath!
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    override func setUp() {
        super.setUp()
        calcMathTest = CalcMath()
        SavedData.conversionSettings = ConversionSettingsModel(systMain: "Decimal", systConverter: "Binary", number: 8.0)
        
    }
    
    override func tearDown() {
        calcMathTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // XCTAssert to test model
    func testCalcDecAdd() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst = "12"
        let decSecond = "10"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .add, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "22", "Claculation failure")
    }
    
    func testCalcDecSub() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst = "12"
        let decSecond = "10"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .sub, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "2", "Claculation failure")
    }
    
    func testCalcDecMul() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst = "12"
        let decSecond = "10"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .mul, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "120", "Claculation failure")
    }
    
    func testCalcDecDiv() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst = "12"
        let decSecond = "10"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .div, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "1.2", "Claculation failure")
    }
   
}
