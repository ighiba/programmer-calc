//
//  HexadecimalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 31.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

//import Foundation
//
//import XCTest
//@testable import ProgrammerCalc
//
//class HexadecimalTests: XCTestCase {
//    
//    let storage = CalculatorStorage()
//    
//    var hexadecimalTest: Hexadecimal!
//    var hexadecimalStrInput: String = "AF0" // dec = 2800
//    
//    let unsignedData = CalculatorState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
//    let signedData = CalculatorState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
//    
//    let calcState: CalculatorState = CalculatorState.shared
//    
//    override func setUp() {
//        super.setUp()
//        hexadecimalTest = Hexadecimal()
//        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .hex, number: 8)
//        storage.saveData(dummyConversionSettings)
//    }
//    
//    override func tearDown() {
//        hexadecimalTest = nil
//        super.tearDown()
//    }
//
//    func testHexadecimalUnsignedInit() throws {
//        // 1. given
//        calcState.setCalcState(unsignedData)
//        
//        // 2. when
//        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
//        
//        // 3. then
//        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
//    }
//    
//    func testHexadecimalSignedInit() throws {
//        // 1. given
//        calcState.setCalcState(signedData)
//        
//        // 2. when
//        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
//        // 3. then
//        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
//    }
//    
//    func testHexadecimalBinaryUnsignedInit() throws {
//        // 1. given
//        calcState.setCalcState(unsignedData)
//        let binary = Binary(stringLiteral: "101011110000")
//        binary.isSigned = false
//        
//        // 2. when
//        hexadecimalTest = Hexadecimal(binary)
//        
//        // 3. then
//        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
//    }
//    
//    func testHexadecimalBinarySignedInit() throws {
//        // 1. given
//        calcState.setCalcState(signedData)
//        let binary = Binary(stringLiteral: "101011110000")
//        binary.isSigned = true
//
//        // 2. when
//        hexadecimalTest = Hexadecimal(binary)
//        
//        // 3. then
//        XCTAssertEqual(hexadecimalTest.value, "AF0", "Converted values are wrong")
//    }
//    
//    func testHexadecimalBinarySignedInitWithMinus() throws {
//        // 1. given
//        calcState.setCalcState(signedData)
//        let binary = Binary()
//        binary.value = "1000101011110000"
//        binary.isSigned = true
//        
//        // 2. when
//        hexadecimalTest = Hexadecimal(binary)
//        
//        // 3. then
//        XCTAssertEqual(hexadecimalTest.value, "8AF0", "Converted values are wrong")
//    }
//    
//    func testHexadecimalBinaryUnsignedInitWithMinus() throws {
//        // 1. given
//        calcState.setCalcState(unsignedData)
//        let binary = Binary()
//        binary.value = "1000101011110000"
//        binary.isSigned = false
//        
//        // 2. when
//        hexadecimalTest = Hexadecimal(binary)
//        
//        // 3. then
//        XCTAssertEqual(hexadecimalTest.value, "8AF0", "Converted values are wrong")
//    }
//    
//    func testToBinary() throws {
//        // 1. given
//        calcState.setCalcState(signedData)
//        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
//        
//        // 2. when
//        let binary = hexadecimalTest.toBinary()
//        
//        // 3. then
//        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000000000101011110000", "Converted values are wrong")
//    }
//    
//    func testHexadecimalToBinaryUnsigned() throws {
//        // 1. given
//        calcState.setCalcState(unsignedData)
//        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
//        
//        // 2. when
//        let binary = hexadecimalTest.toBinary()
//        
//        // 3. then
//        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000000000101011110000", "Converted values are wrong")
//    }
//    
//    func testHexadecimalToBinarySigned() throws {
//        // 1. given
//        calcState.setCalcState(signedData)
//        hexadecimalTest = Hexadecimal(stringLiteral: hexadecimalStrInput)
//        
//        // 2. when
//        let binary = hexadecimalTest.toBinary()
//        
//        // 3. then
//        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000000000101011110000", "Converted values are wrong")
//    }
//}
