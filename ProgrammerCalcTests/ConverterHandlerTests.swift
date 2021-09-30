//
//  ConverterHandlerTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 31.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class ConverterHandlerTests: XCTestCase {
    
    var converterHandlerTest: ConverterHandler!
    let binaryStrInput = "1100"
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    override func setUp() {
        super.setUp()
        converterHandlerTest = ConverterHandler()
        SavedData.conversionSettings = ConversionSettings(systMain: "Decimal", systConverter: "Binary", number: 8.0)
        
    }
    
    override func tearDown() {
        converterHandlerTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // XCTAssert to test model
    func testOnesComplementUnsigned() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let convertedStr = converterHandlerTest.toOnesComplement(valueStr: binary.value, mainSystem: "Binary")
        
        // 3. then
        XCTAssertEqual(convertedStr, "0011", "Converted values are wrong")
    }
    
    func testOnesComplementSigned() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let convertedStr = converterHandlerTest.toOnesComplement(valueStr: binary.value, mainSystem: "Binary")
        
        // 3. then
        XCTAssertEqual(convertedStr, "0111 0011", "Converted values are wrong")
    }
    
    func testTwosComplementUnsigned() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let convertedStr = converterHandlerTest.toTwosComplement(valueStr: binary.value, mainSystem: "Binary")
        
        // 3. then
        XCTAssertEqual(convertedStr, "0100", "Converted values are wrong")
    }
    
    func testTwosComplementSigned() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let convertedStr = converterHandlerTest.toTwosComplement(valueStr: binary.value, mainSystem: "Binary")
        
        // 3. then
        XCTAssertEqual(convertedStr, "0111 0100", "Converted values are wrong")
    }
    
    func testBitwiseShiftLeftUnsigned() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: <<, shiftCount: 1)
        
        // 3. then
        XCTAssertEqual(convertedStr, "0001 1000", "Failed shifting left")
    }
    
    func testBitwiseShiftLeftSigned() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: "11110100") // -12
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: <<, shiftCount: 1)
        
        // 3. then
        XCTAssertEqual(convertedStr, "1110 1000", "Failed shifting left") // -24
    }
    
    func testBitwiseShiftRightUnsigned() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: binaryStrInput)
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: >>, shiftCount: 1)
        
        // 3. then
        XCTAssertEqual(convertedStr, "0110", "Failed shifting right")
    }
    
    func testBitwiseShiftRightSigned() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: "11110100") // -12
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: >>, shiftCount: 1)
        
        // 3. then
        XCTAssertEqual(convertedStr, "1111 1010", "Failed shifting right") // -6
    }
    
    func testBitwiseShiftTwelveRightUnsigned() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: binaryStrInput) // 12
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: <<, shiftCount: 12)
        
        // 3. then
        XCTAssertEqual(convertedStr, "1100 0000 0000 0000", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightUnsigned() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: binaryStrInput) // 12
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: >>, shiftCount: 2)
        
        // 3. then
        XCTAssertEqual(convertedStr, "0011", "Failed shifting 2 right")
    }
    
    func testBitwiseShiftTwelveLeftSigned() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: binaryStrInput) // 12
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: <<, shiftCount: 12)
        
        // 3. then
        XCTAssertEqual(convertedStr, "0000 0000 0000 0000 1100 0000 0000 0000", "Failed shifting 12 left")
    }
    
    func testBitwiseShiftTwoRightSigned() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: binaryStrInput) // 12
        
        // 2. when
        let convertedStr = converterHandlerTest.shiftBits(value: binary.value, mainSystem: "Binary", shiftOperation: >>, shiftCount: 2)
        
        // 3. then
        XCTAssertEqual(convertedStr, "0000 0011", "Failed shifting 2 right")
    }
}
