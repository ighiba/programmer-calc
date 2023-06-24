//
//  LabelFormatterTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 09.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import XCTest
@testable import ProgrammerCalc

class LabelFormatterTests: XCTestCase {
    
    var labelFormatterTest: LabelFormatter!
    
    let unsignedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    let signedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
    
    let qword = WordSize(.qword)
    let dword = WordSize(.dword)
    let word = WordSize(.word)
    let byte = WordSize(.byte)

    let wordSize = WordSize.shared
    let calcState: CalcState = CalcState.shared
    let conversionSettings: ConversionSettings = ConversionSettings.shared
    
    override func setUp() {
        super.setUp()
        labelFormatterTest = LabelFormatter()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        conversionSettings.setConversionSettings(dummyConversionSettings)
        calcState.setCalcState(signedData)
    }
    
    override func tearDown() {
        labelFormatterTest = nil
        super.tearDown()
    }

    // MARK: - isInputOverflowed

    func testIsFloatValueOverflowed_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let currentValue = PCDecimal(string: "127.1234567")!
        let testValue = DecimalSystem(stringLiteral: "127.12345678")
        
        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }

    func testIsFloatValueOverflowed_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let currentValue = PCDecimal(string: "127.1234568")!
        let testValue = DecimalSystem(stringLiteral: "127.123456789")
        
        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }

    func testIsValueOverflowed_BYTE_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let currentValue = PCDecimal(string: "12.0")!
        let testValue = DecimalSystem(stringLiteral: "127")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }

    func testIsValueOverflowed_BYTE_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let currentValue = PCDecimal(string: "12.0")!
        let testValue = DecimalSystem(stringLiteral: "128")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }

    func testIsValueOverflowed_BIN_BYTE_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let currentValue = PCDecimal(string: "100.0")!
        let testValue = Binary(stringLiteral: "100000000")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }

    func testIsValueOverflowed_WORD_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let currentValue = PCDecimal(string: "3276.0")!
        let testValue = DecimalSystem(stringLiteral: "32767")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }

    func testIsValueOverflowed_WORD_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let currentValue = PCDecimal(string: "3276.0")!
        let testValue = DecimalSystem(stringLiteral: "32768")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }

    func testIsValueOverflowed_DWORD_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(dword)
        let currentValue = PCDecimal(string: "214748364.0")!
        let testValue = DecimalSystem(stringLiteral: "2147483647")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }

    func testIsValueOverflowed_DWORD_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(dword)
        let currentValue = PCDecimal(string: "214748364.0")!
        let testValue = DecimalSystem(stringLiteral: "2147483648")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }

    func testIsValueOverflowed_QWORD_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(qword)
        let currentValue = PCDecimal(string: "922337203685477580.0")!
        let testValue = DecimalSystem(stringLiteral: "9223372036854775807")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }

    func testIsValueOverflowed_QWORD_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(qword)
        let currentValue = PCDecimal(string: "922337203685477580.0")!
        let testValue = DecimalSystem(stringLiteral: "9223372036854775808")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }

    func testIsValueOverflowed_QWORD_UNSIGNED_OK() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(qword)
        let currentValue = PCDecimal(string: "1844674407370955161.0")!
        let testValue = DecimalSystem(stringLiteral: "18446744073709551615")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }

    func testIsValueOverflowed_QWORD_UNSIGNED_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(qword)
        let currentValue = PCDecimal(string: "1844674407370955161.0")!
        let testValue = DecimalSystem(stringLiteral: "18446744073709551616")

        // 2. when
        let result = labelFormatterTest.isInputOverflowed(testValue.value, for: .dec, currentValue: currentValue)

        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }

    // MARK: - Process string input
    func testProcessStrInput() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let testValue = "000 1111"

        // 2. when
        let result = labelFormatterTest.processStrInputToFormat(inputStr: testValue, for: .bin)

        // 3. then
        XCTAssertEqual(result, "0000 0000 0000 1111", "Processing failure")
    }
}

