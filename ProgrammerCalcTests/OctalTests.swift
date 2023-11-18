//
//  OctalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 31.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class OctalTests: XCTestCase {
    
    let storage = CalculatorStorage()
    
    var octalTest: Octal!
    var octalStrInput: String = "357" // dec = 239
    
    let unsignedData = CalcState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    let signedData = CalcState(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
    
    let calcState: CalcState = CalcState.shared
    
    override func setUp() {
        super.setUp()
        octalTest = Octal()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .oct, number: 8)
        storage.saveData(dummyConversionSettings)
        
    }
    
    override func tearDown() {
        octalTest = nil
        storage.saveData(ConversionSettings(systMain: .dec, systConverter: .bin, number: 8))
        super.tearDown()
    }

    func testOctalUnsignedInit() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        
        // 2. when
        octalTest = Octal(stringLiteral: octalStrInput)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalSignedInit() throws {
        // 1. given
        calcState.setCalcState(signedData)
        
        // 2. when
        octalTest = Octal(stringLiteral: octalStrInput)
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalBinaryUnsignedInit() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        let binary = Binary(stringLiteral: "011101111")
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalBinarySignedInit() throws {
        // 1. given
        calcState.setCalcState(signedData)
        let binary = Binary(stringLiteral: "011101111")
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "357", "Converted values are wrong")
    }
    
    func testOctalBinarySignedInitWithMinus() throws {
        // 1. given
        calcState.setCalcState(signedData)
        let binary = Binary()
        binary.value = "1000000011101111"
        binary.isSigned = true
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "100357", "Converted values are wrong")
    }
    
    func testOctalBinaryUnsignedInitWithMinus() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        let binary = Binary()
        binary.value = "1000000011101111"
        binary.isSigned = false
        
        // 2. when
        octalTest = Octal(binary)
        
        // 3. then
        XCTAssertEqual(octalTest.value, "100357", "Converted values are wrong")
    }
    
    func testToBinary() throws {
        // 1. given
        calcState.setCalcState(signedData)
        octalTest = Octal(stringLiteral: octalStrInput)
        
        // 2. when
        let binary = octalTest.toBinary()
        
        // 3. then
        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000000000000011101111", "Converted values are wrong")
    }
    
    func testOctalToBinaryUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        octalTest = Octal(stringLiteral: octalStrInput)
        
        // 2. when
        let binary = octalTest.toBinary()
        
        // 3. then
        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000000000000011101111", "Converted values are wrong")
    }
    
    func testOctalToBinarySigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        octalTest = Octal(stringLiteral: octalStrInput)
        
        // 2. when
        let binary = octalTest.toBinary()
        
        // 3. then
        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000000000000011101111", "Converted values are wrong")
    }
}
