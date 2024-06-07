//
//  Calculator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

typealias PCNumberInput = PCNumber & PCNumberDigits

final class PCOperation {
    var bufferValue: PCNumber
    var binaryOperator: BinaryOperator
    
    init(bufferValue: PCNumber, binaryOperator: BinaryOperator) {
        self.bufferValue = bufferValue
        self.binaryOperator = binaryOperator
    }
}

protocol Calculator {
    var calculatorPresenterDelegate: CalculatorPresenterDelegate! { get set }
    func load()
    func reload()
    func clearButtonDidPress()
    func negateInputValue()
    func removeLeastSignificantDigit()
    func getInputValueBits() -> [Bit]
    func dotButtonDidPress()
    func numericButtonDidPress(digit: NumericButton.Digit)
    func complementButtonDidPress(complementOperator: ComplementOperator)
    func unaryOperatorButtonDidPress(unaryOperator: UnaryOperator)
    func binaryOperatorButtonDidPress(binaryOperator: BinaryOperator)
    func calculateButtonDidPress()
    func bitButtonDidPress(bitIsOn: Bool, atIndex bitIndex: UInt8)
}

final class CalculatorImpl: Calculator {
    
    // MARK: - Properties
    
    weak var calculatorPresenterDelegate: CalculatorPresenterDelegate!
    
    private var currentOperation: PCOperation?
    private var isFractionalInputStarted: Bool = false
    private var inputValue: PCNumberInput {
        didSet {
            calculatorState.lastValue = inputValue.pcDecimalValue.fixedOverflow(bitWidth: wordSize.bitWidth, isSigned: calculatorState.isSigned)
        }
    }
    
    private let wordSize: WordSize
    private let calculatorState: CalculatorState
    private let conversionSettings: ConversionSettings
    
    // MARK: - Init
    
    init(wordSize: WordSize, calculatorState: CalculatorState, conversionSettings: ConversionSettings) {
        self.inputValue = PCDecimal.zero
        self.wordSize = wordSize
        self.calculatorState = calculatorState
        self.conversionSettings = conversionSettings
    }
    
    // MARK: - Methods
    
    func load() {
        inputValue = convert(calculatorState.lastValue, to: conversionSettings.inputSystem)
        
        updateLabels(withInputValue: inputValue)
    }
    
    func reload() {
        inputValue = convert(inputValue, to: conversionSettings.inputSystem)
        
        updateLabels(withInputValue: inputValue)
    }
    
    func clearButtonDidPress() {
        isFractionalInputStarted = false
        currentOperation = nil
        inputValue.reset()
        
        updateLabels(withInputValue: inputValue)
    }
    
    func negateInputValue() {
        inputValue = convert(-inputValue.pcDecimalValue, to: conversionSettings.inputSystem)

        updateLabels(withInputValue: inputValue)
    }
    
    func removeLeastSignificantDigit() {
        let hasFractionalDigits = !inputValue.fractDigits.isEmpty
        
        if isFractionalInputStarted {
            isFractionalInputStarted = false
        } else if hasFractionalDigits {
            inputValue.removeLeastSignificantFractionalDigit()
        } else {
            inputValue.removeLeastSignificantIntegerDigit()
        }

        updateLabels(withInputValue: inputValue)
    }
    
    func getInputValueBits() -> [Bit] {
        let decimal = inputValue.pcDecimalValue.fixedOverflow(bitWidth: wordSize.bitWidth, isSigned: calculatorState.isSigned)
        let binary = PCBinary(pcDecimal: decimal)
        
        return binary.intPart.bits
    }
    
    func dotButtonDidPress() {
        guard !isFractionalInputStarted && inputValue.fractDigits.isEmpty else { return }
        
        isFractionalInputStarted = true
    
        let bitWidth = wordSize.bitWidth
        let inputText = inputValue.formattedInput(bitWidth: bitWidth) + "."
        
        calculatorPresenterDelegate.setInputLabelText(inputText)
    }
    
    func numericButtonDidPress(digit: NumericButton.Digit) {
        let bitWidth = wordSize.bitWidth
        let fractionalWidth = conversionSettings.fractionalWidth
        let isSigned = calculatorState.isSigned
        
        let isIntegerInput = !(isFractionalInputStarted || !inputValue.fractDigits.isEmpty)
        if isIntegerInput {
            inputValue.appendIntegerDigits(digit.digitsToAppend, bitWidth: bitWidth, isSigned: isSigned)
        } else {
            inputValue.appendFractionalDigits(digit.digitsToAppend, fractionalWidth: fractionalWidth)
            isFractionalInputStarted = false
        }
        
        updateLabels(withInputValue: inputValue)
    }
    
    func complementButtonDidPress(complementOperator: ComplementOperator) {
        let result = calculateComplementOperation(inputValue, complementOperator: complementOperator)
        
        currentOperation = nil
        inputValue = convert(result, to: conversionSettings.inputSystem)
        
        updateLabels(withInputValue: inputValue)
    }
    
    func unaryOperatorButtonDidPress(unaryOperator: UnaryOperator) {
        let result = calculateUnaryOperation(inputValue, unaryOperator: unaryOperator)
        
        currentOperation = nil
        inputValue = convert(result, to: conversionSettings.inputSystem)
        
        updateLabels(withInputValue: inputValue)
    }
    
    func binaryOperatorButtonDidPress(binaryOperator: BinaryOperator) {
        if let pendingOperation = currentOperation {
            do {
                let newBufferValue = try calculateBinaryOperation(lhs: pendingOperation.bufferValue, rhs: inputValue, binaryOperator: pendingOperation.binaryOperator)
                
                currentOperation?.bufferValue = newBufferValue
                currentOperation?.binaryOperator = binaryOperator
                
                inputValue.reset()
                
                updateLabels(withInputValue: newBufferValue)
            } catch(let error) {
                handleCalculationError(error)
            }
        } else {
            currentOperation = PCOperation(bufferValue: inputValue, binaryOperator: binaryOperator)
            inputValue.reset()
        }
    }
    
    func calculateButtonDidPress() {
        guard let pendingOperation = currentOperation else { return }
        
        do {
            let calculatedValue = try calculateBinaryOperation(lhs: pendingOperation.bufferValue, rhs: inputValue, binaryOperator: pendingOperation.binaryOperator)
            
            currentOperation = nil
            inputValue = convert(calculatedValue, to: conversionSettings.inputSystem)
            
            updateLabels(withInputValue: inputValue)
        } catch(let error) {
            handleCalculationError(error)
        }
    }
    
    func bitButtonDidPress(bitIsOn: Bool, atIndex bitIndex: UInt8) {
        let bit: UInt8 = bitIsOn ? 1 : 0
        
        let decimal = inputValue.pcDecimalValue.fixedOverflow(bitWidth: wordSize.bitWidth, isSigned: calculatorState.isSigned)
        var binary = PCBinary(pcDecimal: decimal)
        binary.switchBit(bit, atIndex: bitIndex)
        
        inputValue = convert(binary, to: conversionSettings.inputSystem)
        
        updateLabels(withInputValue: inputValue)
    }
    
    private func calculateComplementOperation(_ pcNumber: PCNumber, complementOperator: ComplementOperator) -> PCNumberInput {
        let bitWidth = wordSize.bitWidth
        let isSigned = calculatorState.isSigned
        
        let decimal = pcNumber.pcDecimalValue.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned)
        
        switch complementOperator {
        case .oneS:
            return ~decimal
        case .twoS:
            return ~decimal + 1
        }
    }
    
    private func calculateUnaryOperation(_ pcNumber: PCNumber, unaryOperator: UnaryOperator) -> PCNumberInput {
        let bitWidth = wordSize.bitWidth
        let isSigned = calculatorState.isSigned
        
        let decimal = pcNumber.pcDecimalValue.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned)

        switch unaryOperator {
        case .shiftLeft:
            return decimal << 1
        case .shiftRight:
            return decimal >> 1
        }
    }
    
    private func calculateBinaryOperation(lhs: PCNumber, rhs: PCNumber, binaryOperator: BinaryOperator) throws -> PCNumberInput {
        let bitWidth = wordSize.bitWidth
        let isSigned = calculatorState.isSigned
        
        let lhsDecimal = lhs.pcDecimalValue.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned)
        let rhsDecimal = rhs.pcDecimalValue.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned)
        
        switch binaryOperator {
        case .add:
            return lhsDecimal + rhsDecimal
        case .sub:
            return lhsDecimal - rhsDecimal
        case .mul:
            return lhsDecimal * rhsDecimal
        case .div:
            guard rhsDecimal != 0 else { throw MathError.divByZero }
            return lhsDecimal / rhsDecimal
        case .shiftLeftBy:
            return lhsDecimal << rhsDecimal
        case .shiftRightBy:
            return lhsDecimal >> rhsDecimal
        case .and:
            return lhsDecimal & rhsDecimal
        case .or:
            return lhsDecimal | rhsDecimal
        case .xor:
            return lhsDecimal ^ rhsDecimal
        case .nor:
            return ~(lhsDecimal ^ rhsDecimal)
        }
    }
    
    private func handleCalculationError(_ error: Error) {
        currentOperation = nil
        inputValue.reset()
        
        calculatorPresenterDelegate.setInputLabelText(error.localizedDescription)
        calculatorPresenterDelegate.setOutputLabelText("NaN")
    }
    
    private func updateLabels(withInputValue inputValue: PCNumberInput) {
        let outputValue = convert(inputValue, to: conversionSettings.outputSystem)
        
        let bitWidth = wordSize.bitWidth
        let fractionalWidth = conversionSettings.fractionalWidth
        
        let inputText = inputValue.formattedInput(bitWidth: bitWidth)
        let outputText = outputValue.formattedOutput(bitWidth: bitWidth, fractionalWidth: fractionalWidth)
        
        calculatorPresenterDelegate.setInputLabelText(inputText)
        calculatorPresenterDelegate.setOutputLabelText(outputText)
        
        calculatorState.inputText = inputText
        calculatorState.outputText = outputText
    }
    
    private func convert<T: PCNumber>(_ pcNumber: T, to conversionSystem: ConversionSystem) -> PCNumberInput {
        let bitWidth = wordSize.bitWidth
        let isSigned = calculatorState.isSigned
        
        return conversionSystem.pcNumberInputType.init(pcDecimal: pcNumber.pcDecimalValue, bitWidth: bitWidth, isSigned: isSigned)
    }
}

extension ConversionSystem {
    var pcNumberInputType: PCNumberInput.Type {
        switch self {
        case .bin:
            return PCBinary.self
        case .oct:
            return PCOctal.self
        case .dec:
            return PCDecimal.self
        case .hex:
            return PCHexadecimal.self
        }
    }
}

extension PCNumberDigits {
    mutating func appendIntegerDigits(_ digits: [Digit], bitWidth: UInt8, isSigned: Bool) {
        for digit in digits {
            appendIntegerDigit(digit, bitWidth: bitWidth, isSigned: isSigned)
        }
    }
    
    mutating func appendFractionalDigits(_ digits: [Digit], fractionalWidth: UInt8) {
        for digit in digits {
            appendFractionalDigit(digit, fractionalWidth: fractionalWidth)
        }
    }
}
