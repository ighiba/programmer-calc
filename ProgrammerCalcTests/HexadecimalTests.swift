//
//  HexadecimalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 31.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class HexadecimalTests: XCTestCase {
    
    var hexadecimalTest: Hexadecimal!
    var hexadecimalStrInput: String = "AF0" // dec = 2800
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    override func setUp() {
        super.setUp()
        hexadecimalTest = Hexadecimal()
        SavedData.conversionSettings = ConversionSettingsModel(systMain: "Decimal", systConverter: "Hexadecimal", number: 8.0)
        
    }
    
    override func tearDown() {
        hexadecimalTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // XCTAssert to test model
    func testHexadecimalUnsignedInit() throws {
        // 1. given
        SavedData.calcState = unsignedData
        
        // 2. when
        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
        
        // 3. then
        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
    }
    
    func testHexadecimalSignedInit() throws {
        // 1. given
        SavedData.calcState = signedData
        
        // 2. when
        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
        // 3. then
        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
    }
    
    func testHexadecimalBinaryUnsignedInit() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: "101011110000")
        
        // 2. when
        hexadecimalTest = Hexadecimal(binary)
        
        // 3. then
        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
    }
    
    func testHexadecimalBinarySignedInit() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: "101011110000")
        
        // 2. when
        hexadecimalTest = Hexadecimal(binary)
        
        // 3. then
        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
    }
    
    func testHexadecimalBinarySignedInitWithMinus() throws {
        // 1. given
        SavedData.calcState = signedData
        let binary = Binary(stringLiteral: "1000101011110000")
        
        // 2. when
        hexadecimalTest = Hexadecimal(binary)
        
        // 3. then
        XCTAssertEqual(hexadecimalTest.value, "8AF0", "Converted values are wrong")
    }
    
    func testHexadecimalBinaryUnsignedInitWithMinus() throws {
        // 1. given
        SavedData.calcState = unsignedData
        let binary = Binary(stringLiteral: "1000101011110000")
        
        // 2. when
        hexadecimalTest = Hexadecimal(binary)
        
        // 3. then
        XCTAssertEqual(hexadecimalTest.value, "8AF0", "Converted values are wrong")
    }
    
    func testHexadecimalCovnertToBinaryUnsigned() throws {
        // 1. given
        SavedData.calcState = unsignedData
        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
        
        // 2. when
        let binary = hexadecimalTest.convertHexToBinary()
        
        // 3. then
        XCTAssertEqual(binary.value, "101011110000", "Converted values are wrong")
    }
    
    func testHexadecimalCovnertToBinarySigned() throws {
        // 1. given
        SavedData.calcState = signedData
        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
        
        // 2. when
        let binary = hexadecimalTest.convertHexToBinary()
        
        // 3. then
        XCTAssertEqual(binary.value, "0000101011110000", "Converted values are wrong")
    }
    
    
    
}
