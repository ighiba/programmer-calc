//
//  CalculatorTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 29.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import XCTest
@testable import ProgrammerCalc

class CalculatorTests: XCTestCase {

    // Storages
    var conversionStorage: ConversionStorageProtocol? = ConversionStorage()
    let calcStateStorage: CalcStateStorageProtocol? = CalcStateStorage()
    
    var legacyCalculatorTest: LegacyCalculator!
    var calculatorTest: Calculator!
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    let byte = WordSize(8)
    let word = WordSize(16)
    let dword = WordSize(32)
    let qword = WordSize(64)
    
    let wordSize = WordSize.shared
    let calcState: CalcState = CalcState.shared
    
    override func setUp() {
        super.setUp()
        legacyCalculatorTest = LegacyCalculator()
        calculatorTest = Calculator()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        conversionStorage?.saveData(dummyConversionSettings)
        calcStateStorage?.saveData(signedData)
    }
    
    override func tearDown() {
        legacyCalculatorTest = nil
        super.tearDown()
    }
    
    // MARK: - Negate
    
    func testNegateCurrentValue_BYTE() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let testValue = PCDecimal(12)
        
        // 2. when
        calculatorTest.currentValue = testValue
        calculatorTest.negateCurrentValue()
        let result = calculatorTest.currentValue.getDecimal()

        // 3. then
        XCTAssertEqual(result, -12.0, "Negation failure")
    }
    
    func testNegateCurrentValue_WORD() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let testValue = PCDecimal(32767)
        
        // 2. when
        calculatorTest.currentValue = testValue
        calculatorTest.negateCurrentValue()
        let result = calculatorTest.currentValue.getDecimal()
        
        // 3. then
        XCTAssertEqual(result, -32767.0, "Negation failure")
    }
    
    func testNegateCurrentValue_DWORD() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(dword)
        let testValue = PCDecimal(2147483647)
        
        // 2. when
        calculatorTest.currentValue = testValue
        calculatorTest.negateCurrentValue()
        let result = calculatorTest.currentValue.getDecimal()

        // 3. then
        XCTAssertEqual(result, -2147483647.0, "Negation failure")
    }
    
    func testNegateCurrentValueFail_QWORD() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(qword)
        let testValue = PCDecimal(value: Decimal(string: "-9223372036854775808")!)
        
        // 2. when
        calculatorTest.currentValue = testValue
        calculatorTest.negateCurrentValue()
        calculatorTest.currentValue.fixOverflow(bitWidth: qword.value, processSigned: true)
        let result = calculatorTest.currentValue.getDecimal()

        // 3. then
        XCTAssertEqual(result.description, "-9223372036854775808", "Negation failure")
    }

    // MARK: - isInputOverflowed
    
    func testIsFloatValueOverflowed_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let testValue = DecimalSystem(stringLiteral: "127.12345678")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsFloatValueOverflowed_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let testValue = DecimalSystem(stringLiteral: "127.123456789")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_BYTE_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let testValue = DecimalSystem(stringLiteral: "127")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_BYTE_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let testValue = DecimalSystem(stringLiteral: "128")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_BIN_BYTE_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(byte)
        let testValue = Binary(stringLiteral: "100000000")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .bin)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_WORD_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let testValue = DecimalSystem(stringLiteral: "32767")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_WORD_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let testValue = DecimalSystem(stringLiteral: "32768")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_DWORD_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(dword)
        let testValue = DecimalSystem(stringLiteral: "2147483647")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_DWORD_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(dword)
        let testValue = DecimalSystem(stringLiteral: "2147483648")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_OK() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(qword)
        let testValue = DecimalSystem(stringLiteral: "9223372036854775807")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(qword)
        let testValue = DecimalSystem(stringLiteral: "9223372036854775808")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_UNSIGNED_OK() throws {
        // 1. given
        calcState.setCalcState(unsignedData)
        wordSize.setWordSize(qword)
        let testValue = DecimalSystem(stringLiteral: "18446744073709551615")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_UNSIGNED_ERROR() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(qword)
        let testValue = DecimalSystem(stringLiteral: "18446744073709551616")
        
        // 2. when
        let result = calculatorTest.isInputOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    // MARK: - Process string inout
    func testProcessStrInput() throws {
        // 1. given
        calcState.setCalcState(signedData)
        wordSize.setWordSize(word)
        let testValue = "000 1111"
        
        // 2. when
        let result = calculatorTest.processStrInputToFormat(inputStr: testValue, for: .bin)
        
        // 3. then
        XCTAssertEqual(result, "0000 0000 0000 1111", "Processing failure")
    }

}
