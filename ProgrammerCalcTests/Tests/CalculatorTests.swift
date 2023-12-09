//
//  CalculatorTests.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 29.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import XCTest
@testable import ProgrammerCalc

final class CalculatorTests: XCTestCase {
    
    var calculatorTest: Calculator!
    let calculatorPresenterMock = CalculatorPresenterMock()

    let wordSize = WordSize(.byte)
    let calculatorState = CalculatorState(lastValue: .zero, lastLabelValues: LabelValues(main: "", converter: ""), processSigned: true)
    let conversionSettings = ConversionSettings(inputSystem: .dec, outputSystem: .bin, fractionalWidth: 8)
    
    override func setUp() {
        super.setUp()
        calculatorTest = CalculatorImpl(wordSize: wordSize, calculatorState: calculatorState, conversionSettings: conversionSettings)
        calculatorTest.calculatorPresenterDelegate = calculatorPresenterMock
        calculatorTest.load()
    }
    
    override func tearDown() {
        calculatorTest = nil
        super.tearDown()
    }
    
    func testInput() throws {
        // 1. given
        let integerDigits: [NumericButton.Digit] = [.single("1"), .single("2"), .single("3")]
        let fractionalDigits: [NumericButton.Digit] = [.single("0"), .single("0"), .single("5")]
        
        // 2. when
        for digit in integerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.dotButtonDidPress()

        for digit in fractionalDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        let inputText = calculatorPresenterMock.inputText
        let outputText = calculatorPresenterMock.outputText
        
        // 3. then
        XCTAssertEqual(inputText, "123.005", "Input text failure")
        XCTAssertEqual(outputText, "0111 1011.0000 0001", "Output text failure")
    }

    func testInvalidInput() throws {
        // 1. given
        let integerDigits: [NumericButton.Digit] = [.single("1"), .single("i"), .double("0", "0"), .single("^")]
        
        // 2. when
        for digit in integerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        let inputText = calculatorPresenterMock.inputText
        let outputText = calculatorPresenterMock.outputText
        
        // 3. then
        XCTAssertEqual(inputText, "100", "Input text failure")
        XCTAssertEqual(outputText, "0110 0100", "Output text failure")
    }
    
    func testNegate() throws {
        // 1. given
        let integerDigits: [NumericButton.Digit] = [.single("1"), .single("2"), .single("3")]
        
        // 2. when
        for digit in integerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.negateInputValue()
        
        let inputText = calculatorPresenterMock.inputText
        let outputText = calculatorPresenterMock.outputText
        
        // 3. then
        XCTAssertEqual(inputText, "-123", "Input text failure")
        XCTAssertEqual(outputText, "1000 0101", "Output text failure")
    }
    
    func testRemoveLeastSignificantDigit() throws {
        // 1. given
        let integerDigits: [NumericButton.Digit] = [.single("1"), .single("2"), .single("3")]
        let fractionalDigits: [NumericButton.Digit] = [.single("5")]
        
        // 2. when
        for digit in integerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.dotButtonDidPress()

        for digit in fractionalDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.removeLeastSignificantDigit()
        calculatorTest.removeLeastSignificantDigit()
        
        let inputText = calculatorPresenterMock.inputText
        let outputText = calculatorPresenterMock.outputText
        
        // 3. then
        XCTAssertEqual(inputText, "12", "Input text failure")
        XCTAssertEqual(outputText, "0000 1100", "Output text failure")
    }
    
    func testCalculation() throws {
        // 1. given
        let lhsIntegerDigits: [NumericButton.Digit] = [.single("4"), .single("0")]
        let rhsIntegerDigits: [NumericButton.Digit] = [.single("2")]
        
        // 2. when
        for digit in lhsIntegerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.binaryOperatorButtonDidPress(binaryOperator: .add)
        
        for digit in rhsIntegerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.calculateButtonDidPress()
        
        let inputText = calculatorPresenterMock.inputText
        let outputText = calculatorPresenterMock.outputText
        
        // 3. then
        XCTAssertEqual(inputText, "42", "Input text failure")
        XCTAssertEqual(outputText, "0010 1010", "Output text failure")
    }

    func testErrorOutput() throws {
        // 1. given
        let lhsIntegerDigits: [NumericButton.Digit] = [.single("1")]
        let rhsIntegerDigits: [NumericButton.Digit] = [.single("0")]
        
        // 2. when
        for digit in lhsIntegerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.binaryOperatorButtonDidPress(binaryOperator: .div)
        
        for digit in rhsIntegerDigits {
            calculatorTest.numericButtonDidPress(digit: digit)
        }
        
        calculatorTest.calculateButtonDidPress()
        
        let inputText = calculatorPresenterMock.inputText
        let outputText = calculatorPresenterMock.outputText
        
        // 3. then
        XCTAssertEqual(inputText, MathError.divByZero.localizedDescription, "Input text failure")
        XCTAssertEqual(outputText, "NaN", "Output text failure")
    }
}
