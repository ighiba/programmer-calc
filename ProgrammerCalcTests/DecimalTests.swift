//
//  DecimalTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 20.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import Foundation

import XCTest
@testable import ProgrammerCalc

class DecimalTests: XCTestCase {
    
    // Storages
    var conversionStorage: ConversionStorageProtocol? = ConversionStorage()
    
    var decimalTest: DecimalSystem!
    var decimalStrInput: String = "12345"
    
    let unsignedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    let signedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
    
    let calcState: CalcState = CalcState.shared
    
    override func setUp() {
        super.setUp()
        decimalTest = DecimalSystem(stringLiteral: "0")
        let dummyConversionSettings = ConversionSettings(systMain: .bin, systConverter: .dec, number: 8)
        conversionStorage?.saveData(dummyConversionSettings)
    }
    
    override func tearDown() {
        decimalTest = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testDecimalUnsignedInit() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        
        // 2. when
        decimalTest = DecimalSystem(stringLiteral: decimalStrInput)
        
        // 3. then
        XCTAssertEqual(decimalTest.value, "12345", "Converted values are wrong")
        XCTAssertEqual(decimalTest.decimalValue, 12345, "Converted values are wrong")
        XCTAssertEqual(decimalTest.isSigned, false, "Signed state is wrong")
    }
    
    func testDecimalSignedInit() throws {
        // 1. given
        calcState.setCalcState(signedData)
        
        // 2. when
        decimalTest = DecimalSystem(stringLiteral: "-\(decimalStrInput)")
        
        // 3. then
        XCTAssertEqual(decimalTest.value, "-12345", "Converted values are wrong")
        XCTAssertEqual(decimalTest.decimalValue, -12345, "Converted values are wrong")
        XCTAssertEqual(decimalTest.isSigned, true, "Signed state is wrong")
    }
    
    func testDecimalBinaryUnsignedInit() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        let binary = Binary(stringLiteral: "0011000000111001") // 12345

        // 2. when
        decimalTest = DecimalSystem(binary)
        
        // 3. then
        XCTAssertEqual(decimalTest.value, decimalStrInput, "Converted values are wrong")
    }
    
    func testDecimalBinarySignedInit() throws {
        // 1. given
        calcState.setCalcState(signedData)
        let binary = Binary(stringLiteral: "1111111111111111111111111111111111111111111111111100111111000111") // -12345
        
        // 2. when
        decimalTest = DecimalSystem(binary)
        
        // 3. then
        XCTAssertEqual(decimalTest.value, "-12345", "Converted values are wrong")
        XCTAssertEqual(decimalTest.decimalValue, -12345, "Converted values are wrong")
        XCTAssertEqual(decimalTest.isSigned, true, "Signed state is wrong")
    }
    
    func testDecimalBinaryUnsignedInitWithMinus() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        let binary = Binary(stringLiteral: "1111111111111111111111111111111111111111111111111100111111000111") // 18446744073709539271
        binary.isSigned = false

        // 2. when
        decimalTest = DecimalSystem(binary)

        // 3. then
        XCTAssertEqual(decimalTest.value, "18446744073709539271", "Converted values are wrong")
        XCTAssertEqual(decimalTest.decimalValue, Decimal(string: "18446744073709539271"), "Converted values are wrong")
        XCTAssertEqual(decimalTest.isSigned, false, "Signed state is wrong")
    }

    func testToBinary() throws {
        // 1. given
        calcState.setCalcState(signedData)
        decimalTest = DecimalSystem(stringLiteral: decimalStrInput)

        // 2. when
        let binary = decimalTest.toBinary()

        // 3. then
        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000000011000000111001", "Converted values are wrong")
    }

    func testHexadecimalCovnertToBinaryUnsigned() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        decimalTest = DecimalSystem(stringLiteral: "65536")

        // 2. when
        let binary = decimalTest.convertDecToBinary()

        // 3. then
        XCTAssertEqual(binary.value, "0000000000000000000000000000000000000000000000010000000000000000", "Converted values are wrong")
    }

    func testHexadecimalCovnertToBinarySigned() throws {
        // 1. given
        calcState.setCalcState(signedData)
        decimalTest = DecimalSystem(stringLiteral: "-65536")

        // 2. when
        let binary = decimalTest.convertDecToBinary()

        // 3. then
        XCTAssertEqual(binary.value, "1111111111111111111111111111111111111111111111110000000000000000", "Converted values are wrong")
    }

    
}
