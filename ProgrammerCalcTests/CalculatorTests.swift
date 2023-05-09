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
    
    var calculatorTest: Calculator!
    
    let unsignedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    let signedData = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: true)
    
    let byte = WordSize(8)
    let word = WordSize(16)
    let dword = WordSize(32)
    let qword = WordSize(64)
    
    let wordSize = WordSize.shared
    let calcState: CalcState = CalcState.shared
    
    override func setUp() {
        super.setUp()
        calculatorTest = Calculator()
        let dummyConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
        conversionStorage?.saveData(dummyConversionSettings)
        calcStateStorage?.saveData(signedData)
    }
    
    override func tearDown() {
        calculatorTest = nil
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


}
