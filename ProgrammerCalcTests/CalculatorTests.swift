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
    var calcStatetorage: CalcStateStorageProtocol? = CalcStateStorage()
    
    var calculatorTest: Calculator!
    
    let unsignedData = CalcState(mainState: "0", convertState: "0", processSigned: false)
    let signedData = CalcState(mainState: "0", convertState: "0", processSigned: true)
    
    let byte = WordSize(8)
    let word = WordSize(16)
    let dword = WordSize(32)
    let qword = WordSize(64)
    
    let wordSize = WordSize.shared
    
    override func setUp() {
        super.setUp()
        calculatorTest = Calculator()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        conversionStorage?.saveData(dummyConversionSettings)
    }
    
    override func tearDown() {
        calculatorTest = nil
        super.tearDown()
    }
    
    // MARK: - Negate BIN
    
    func testNegateValueBIN_BYTE() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = Binary(stringLiteral: "00001100")
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .bin)
        
        // 3. then
        XCTAssertEqual(result, "11110100", "Negation failure")
    }

    func testNegateValueBIN_WORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 16)
        let testValue = Binary(stringLiteral: "00001100")
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .bin)
        
        // 3. then
        XCTAssertEqual(result, "1111111111110100", "Negation failure")
    }
    
    func testNegateValueBIN_DWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 32)
        let testValue = Binary(stringLiteral: "00001100")
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .bin)
        
        // 3. then
        XCTAssertEqual(result, "11111111111111111111111111110100", "Negation failure")
    }
    
    func testNegateValueBIN_QWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 64)
        let testValue = Binary(stringLiteral: "00001100")
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .bin)
        
        // 3. then
        XCTAssertEqual(result, "1111111111111111111111111111111111111111111111111111111111110100", "Negation failure")
    }
    
    // MARK: - Negate DEC
    
    func testNegateValueDEC_BYTE() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = DecimalSystem(12)
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .dec)
        
        // 3. then
        XCTAssertEqual(result, "-12", "Negation failure")
    }

    func testNegateValueDEC_WORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 16)
        let testValue = DecimalSystem(-12)
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .dec)
        
        // 3. then
        XCTAssertEqual(result, "12", "Negation failure")
    }
    
    func testNegateValueDEC_DWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 32)
        let testValue = DecimalSystem(256)
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .dec)
        
        // 3. then
        XCTAssertEqual(result, "-256", "Negation failure")
    }
    
    func testNegateValueDEC_QWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 64)
        let testValue = DecimalSystem(-123456789)
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .dec)
        
        // 3. then
        XCTAssertEqual(result, "123456789", "Negation failure")
    }
    
    // MARK: - Negate OCT
    
    func testNegateValueOCT_BYTE() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = Octal(stringLiteral: "357") // - 17
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .oct)
        
        // 3. then
        XCTAssertEqual(result, "21", "Negation failure")
    }

    func testNegateValueOCT_WORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 16)
        let testValue = Octal(stringLiteral: "357") // 239
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .oct)
        
        // 3. then
        XCTAssertEqual(result, "177421", "Negation failure")
    }
    
    func testNegateValueOCT_DWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 32)
        let testValue = Octal(stringLiteral: "357") // 239
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .oct)
        
        // 3. then
        XCTAssertEqual(result, "37777777421", "Negation failure")
    }
    
    func testNegateValueOCT_QWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 64)
        let testValue = Octal(stringLiteral: "1777777777777777777421") // -239
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .oct)
        
        // 3. then
        XCTAssertEqual(result, "357", "Negation failure") // 239
    }
    
    // MARK: - Negate HEX
    
    func testNegateValueHEX_BYTE() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = Hexadecimal(stringLiteral: "AA") // - 86
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .hex)
        
        // 3. then
        XCTAssertEqual(result, "56", "Negation failure")
    }

    func testNegateValueHEX_WORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 16)
        let testValue = Hexadecimal(stringLiteral: "DAA9") // -9559
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .hex)
        
        // 3. then
        XCTAssertEqual(result, "2557", "Negation failure")
    }
    
    func testNegateValueHEX_DWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 32)
        let testValue = Hexadecimal(stringLiteral: "89632557") // -1989991081
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .hex)
        
        // 3. then
        XCTAssertEqual(result, "769CDAA9", "Negation failure")
    }
    
    func testNegateValueHEX_QWORD() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 64)
        let testValue = Hexadecimal(stringLiteral: "FFFFFFFF769CDAA9") // -2304976215
        
        // 2. when
        let result = calculatorTest.negateValue(value: testValue, system: .hex)
        
        // 3. then
        XCTAssertEqual(result, "89632557", "Negation failure") // 239
    }
    
    // MARK: - isValueOverflowed
    
    func testIsFloatValueOverflowed_OK() throws {
        // 1. given
        let conversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        conversionStorage?.saveData(conversionSettings)
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = DecimalSystem(stringLiteral: "127.12345678")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsFloatValueOverflowed_EROOR() throws {
        // 1. given
        let conversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        conversionStorage?.saveData(conversionSettings)
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = DecimalSystem(stringLiteral: "127.123456789")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_BYTE_OK() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = DecimalSystem(stringLiteral: "127")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_BYTE_ERROR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = DecimalSystem(stringLiteral: "128")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_BIN_BYTE_ERROR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 8)
        let testValue = Binary(stringLiteral: "100000000")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .bin)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_WORD_OK() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 16)
        let testValue = DecimalSystem(stringLiteral: "32767")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_WORD_ERROR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 16)
        let testValue = DecimalSystem(stringLiteral: "32768")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_DWORD_OK() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 32)
        let testValue = DecimalSystem(stringLiteral: "2147483647")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_DWORD_ERROR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 32)
        let testValue = DecimalSystem(stringLiteral: "2147483648")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_OK() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 64)
        let testValue = DecimalSystem(stringLiteral: "9223372036854775807")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_ERROR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 64)
        let testValue = DecimalSystem(stringLiteral: "9223372036854775808")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_UNSIGNED_OK() throws {
        // 1. given
        calcStatetorage?.saveData(unsignedData)
        wordSize.setValue(newValue: 64)
        let testValue = DecimalSystem(stringLiteral: "18446744073709551615")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, false, "Calculation failure")
    }
    
    func testIsValueOverflowed_QWORD_UNSIGNED_ERROR() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 64)
        let testValue = DecimalSystem(stringLiteral: "18446744073709551616")
        
        // 2. when
        let result = calculatorTest.isValueOverflowed(value: testValue.value, for: .dec)
        
        // 3. then
        XCTAssertEqual(result, true, "Calculation failure")
    }
    
    // MARK: - Process string inout
    func testProcessStrInput() throws {
        // 1. given
        calcStatetorage?.saveData(signedData)
        wordSize.setValue(newValue: 16)
        let testValue = "000 1111"
        
        // 2. when
        let result = calculatorTest.processStrInputToFormat(inputStr: testValue, for: .bin)
        
        // 3. then
        XCTAssertEqual(result, "0000 0000 0000 1111", "Processing failure")
    }

}
