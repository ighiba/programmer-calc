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
    
    func testFillUpBits() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let testValue = "10001100"
        
        // 2. when
        let result = calcMathTest.fillUpBits(str: testValue)
        
        // 3. then
        XCTAssertEqual(result, "0000000010001100", "Claculation failure")
    }
    
    // MARK: - ADD
    
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
    
    // MARK: - SUB
    
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
    
    // MARK: - MUL
    
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
    
    // MARK: - DIV
    
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
    
    // MARK: - AND
    
    func testCalcDecUnsignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst = "12"
        let decSecond = "10"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .and, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "8", "Claculation failure")
    }
    
    func testCalcBinUnsignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binFirst = "110001"
        let binSecond = "101010"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "0010 0000", "Claculation failure")
    }
    
    func testCalcHexUnsignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let hexFirst = "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "BEC8", "Claculation failure")
    }
    
    func testCalcOctUnsignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let octFirst = "357"
        let octSecond = "123"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "103", "Claculation failure")
    }
    
    func testCalcDecSignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst = "-12"
        let decSecond = "4"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .and, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "4", "Claculation failure")
    }
    
    func testCalcBinSignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binFirst = "00110001"
        let binSecond = "10101010"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "0010 0000", "Claculation failure")
    }
    
    func testCalcHexSignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let hexFirst = "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "BEC8", "Claculation failure")
    }
    
    func testCalcOctSignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let octFirst = "-357"
        let octSecond = "123"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "103", "Claculation failure")
    }
    
   
}
