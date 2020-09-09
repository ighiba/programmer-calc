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
        XCTAssertEqual(result, "0000000010001100", "Calaculation failure")
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
        XCTAssertEqual(result, "22", "Calaculation failure")
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
        XCTAssertEqual(result, "2", "Calaculation failure")
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
        XCTAssertEqual(result, "120", "Calaculation failure")
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
        XCTAssertEqual(result, "1.2", "Calaculation failure")
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
        XCTAssertEqual(result, "8", "Calaculation failure")
    }
    
    func testCalcBinUnsignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binFirst = "110001"
        let binSecond = "101010"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "0010 0000", "Calaculation failure")
    }
    
    func testCalcHexUnsignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let hexFirst = "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "BEC8", "Calaculation failure")
    }
    
    func testCalcOctUnsignedAND() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let octFirst = "357"
        let octSecond = "123"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "103", "Calaculation failure")
    }
    
    func testCalcDecSignedAND() throws {
        // 1. given
        SavedData.calcState = signedData
        let decFirst = "-12"
        let decSecond = "4"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .and, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "4", "Calaculation failure")
    }
    
    func testCalcBinSignedAND() throws {
        // 1. given
        SavedData.calcState = signedData
        let binFirst =  "10010000" // -16 dec
        let binSecond = "01100011" // 99 dec
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .and, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "0110 0000", "Calaculation failure")
    }
    
    func testCalcHexSignedAND() throws {
        // 1. given
        SavedData.calcState = signedData
        let hexFirst = "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .and, secondValue: hexSecond, for: "Hexadecimal")
        // 3. then
        XCTAssertEqual(result, "BEC8", "Calaculation failure")
    }
    
    func testCalcOctSignedAND() throws {
        // 1. given
        SavedData.calcState = signedData
        let octFirst = "357"
        let octSecond = "123"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .and, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "103", "Calaculation failure")
    }
    
    // MARK: - OR
    
    func testCalcDecUnsignedOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst =  "12"
        let decSecond = "10"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .or, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "14", "Calaculation failure")
    }
    
    func testCalcBinUnsignedOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binFirst =  "110001"
        let binSecond = "101010"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .or, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "0011 1011", "Calaculation failure")
    }
    
    func testCalcHexUnsignedOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let hexFirst =  "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .or, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "FEEF", "Calaculation failure")
    }
    
    func testCalcOctUnsignedOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let octFirst =  "357"
        let octSecond = "123"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .or, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "377", "Calaculation failure")
    }
    
    func testCalcDecSignedOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let decFirst = "-12"
        let decSecond = "4"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .or, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "-12", "Calaculation failure")
    }
    
    func testCalcBinSignedOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let binFirst =  "10010000" // -16 dec
        let binSecond = "01100011" // 99 dec

        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .or, secondValue: binSecond, for: "Binary")

        // 3. then
        XCTAssertEqual(result, "1000 1101", "Calaculation failure")
    }
    
    func testCalcHexSignedOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let hexFirst =  "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .or, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "FEEF", "Calaculation failure")
    }
    
    func testCalcOctSignedOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let octFirst = "207" // -121
        let octSecond = "12" // 10

        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .or, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "217", "Calaculation failure")
    }
    
    // MARK: - XOR
    
    func testCalcDecUnsignedXOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let decFirst =  "12"
        let decSecond = "10"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .xor, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "6", "Calaculation failure")
    }
    
    func testCalcBinUnsignedXOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binFirst =  "110001"
        let binSecond = "101010"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .xor, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "0001 1011", "Calaculation failure")
    }
    
    func testCalcHexUnsignedXOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let hexFirst =  "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .xor, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "4027", "Calaculation failure")
    }
    
    func testCalcOctUnsignedXOR() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let octFirst =  "357"
        let octSecond = "123"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .xor, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "274", "Calaculation failure")
    }
    
    func testCalcDecSignedXOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let decFirst = "-16"
        let decSecond = "99"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .xor, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "-109", "Calaculation failure")
    }
    
    func testCalcBinSignedXOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let binFirst =  "10010000" // -16 dec
        let binSecond = "01100011" // 99 dec

        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .xor, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "1110 1101", "Calaculation failure")
    }
    
    func testCalcHexSignedXOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let hexFirst =  "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .xor, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "4027", "Calaculation failure")
    }
    
    func testCalcOctSignedXOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let octFirst = "357" // -17
        let octSecond = "123" // 83

        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .xor, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "274", "Calaculation failure")
    }
   
   // MARK: - NOR
   
   func testCalcDecUnsignedNOR() throws {
       // 1. given
       SavedData.calcState = unsignedData
       let decFirst =  "12"
       let decSecond = "10"
       
       // 2. when
       let result = calcMathTest.calculate(firstValue: decFirst, operation: .nor, secondValue: decSecond, for: "Decimal")
       
       // 3. then
       XCTAssertEqual(result, "1", "Calaculation failure")
   }
   
   func testCalcBinUnsignedNOR() throws {
       // 1. given
       SavedData.calcState = unsignedData
       let binFirst =  "110001"
       let binSecond = "101010"
       
       // 2. when
       let result = calcMathTest.calculate(firstValue: binFirst, operation: .nor, secondValue: binSecond, for: "Binary")
       
       // 3. then
       XCTAssertEqual(result, "0100", "Calaculation failure")
   }
   
   func testCalcHexUnsignedNOR() throws {
       // 1. given
       SavedData.calcState = unsignedData
       let hexFirst =  "FEED"
       let hexSecond = "BECA"
       
       // 2. when
       let result = calcMathTest.calculate(firstValue: hexFirst, operation: .nor, secondValue: hexSecond, for: "Hexadecimal")
       
       // 3. then
       XCTAssertEqual(result, "110", "Calaculation failure")
   }
   
   func testCalcOctUnsignedNOR() throws {
       // 1. given
       SavedData.calcState = unsignedData
       let octFirst =  "327"
       let octSecond = "123"
       
       // 2. when
       let result = calcMathTest.calculate(firstValue: octFirst, operation: .nor, secondValue: octSecond, for: "Octal")
       
       // 3. then
       XCTAssertEqual(result, "50", "Calaculation failure")
   }
    func testCalcDecSignedNOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let decFirst = "-16"
        let decSecond = "99"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: decFirst, operation: .nor, secondValue: decSecond, for: "Decimal")
        
        // 3. then
        XCTAssertEqual(result, "12", "Calaculation failure")
    }
    
    func testCalcBinSignedNOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let binFirst =  "10010000" // -16 dec
        let binSecond = "01100011" // 99 dec

        // 2. when
        let result = calcMathTest.calculate(firstValue: binFirst, operation: .nor, secondValue: binSecond, for: "Binary")
        
        // 3. then
        XCTAssertEqual(result, "0000 1100", "Calaculation failure")
    }
    
    func testCalcHexSignedNOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let hexFirst =  "FEED"
        let hexSecond = "BECA"
        
        // 2. when
        let result = calcMathTest.calculate(firstValue: hexFirst, operation: .nor, secondValue: hexSecond, for: "Hexadecimal")
        
        // 3. then
        XCTAssertEqual(result, "110", "Calaculation failure")
    }
    
    func testCalcOctSignedNOR() throws {
        // 1. given
        SavedData.calcState = signedData
        let octFirst = "357"
        let octSecond = "123"

        // 2. when
        let result = calcMathTest.calculate(firstValue: octFirst, operation: .nor, secondValue: octSecond, for: "Octal")
        
        // 3. then
        XCTAssertEqual(result, "0", "Calaculation failure")
    }
}
