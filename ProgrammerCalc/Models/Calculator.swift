//
//  Calculator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

typealias PCNumberInput = PCNumber & PCNumberDigits

class PCOperation {
    var bufferValue: PCNumber
    var operatorType: OperatorType
    
    init(bufferValue: PCNumber, operatorType: OperatorType) {
        self.bufferValue = bufferValue
        self.operatorType = operatorType
    }
}

protocol Calculator {
    var calculatorPresenterDelegate: CalculatorPresenterDelegate! { get set }
    func load()
    func reload()
    func clearButtonDidPress()
    func negateInputValue()
    func removeLeastSignificantDigit()
    func dotButtonDidPress()
    func numericButtonDidPress(digit: Character)
    func unaryOperatorButtonDidPress(operatorType: OperatorType)
    func binaryOperatorButtonDidPress(operatorType: OperatorType)
    func calculateButtonDidPress()
    func getInputValueBits() -> [Bit]
    func bitButtonDidPress(bitIsOn: Bool, atIndex bitIndex: UInt8)
}

final class CalculatorImpl: Calculator {
    
    // MARK: - Properties
    
    private var inputValue: PCNumberInput {
        didSet {
            calculatorState.lastValue = inputValue.pcDecimalValue.fixedOverflow(bitWidth: wordSize.bitWidth, isSigned: calculatorState.processSigned)
        }
    }
    
    weak var calculatorPresenterDelegate: CalculatorPresenterDelegate!
    
    private var currentOperation: PCOperation?
    private var isFractionalInputStarted: Bool = false
    
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
    
    func dotButtonDidPress() {
        guard !isFractionalInputStarted && inputValue.fractDigits.isEmpty else { return }
        
        isFractionalInputStarted = true
    
        let bitWidth = wordSize.bitWidth
        let inputText = inputValue.formattedInput(bitWidth: bitWidth) + "."
        
        calculatorPresenterDelegate.setInputLabelText(inputText)
    }
    
    func numericButtonDidPress(digit: Character) {
        let bitWidth = wordSize.bitWidth
        let fractionalWidth = conversionSettings.fractionalWidth
        let isSigned = calculatorState.processSigned
        
        let isIntegerInput = !(isFractionalInputStarted || !inputValue.fractDigits.isEmpty)
        
        if isIntegerInput {
            inputValue.appendIntegerDigit(digit, bitWidth: bitWidth, isSigned: isSigned)
        } else {
            inputValue.appendFractionalDigit(digit, fractionalWidth: fractionalWidth)
            isFractionalInputStarted = false
        }
        
        updateLabels(withInputValue: inputValue)
    }

    func unaryOperatorButtonDidPress(operatorType: OperatorType) {
        let result = calculateUnaryOperation(inputValue, operatorType: operatorType)
        
        currentOperation = nil
        inputValue = convert(result, to: conversionSettings.inputSystem)
        
        updateLabels(withInputValue: inputValue)
    }
    
    func binaryOperatorButtonDidPress(operatorType: OperatorType) {
        if let pendingOperation = currentOperation {
            do {
                let newBufferValue = try calculateBinaryOperation(lhs: pendingOperation.bufferValue, rhs: inputValue, operatorType: pendingOperation.operatorType)
                
                currentOperation?.bufferValue = newBufferValue
                currentOperation?.operatorType = operatorType
                
                inputValue.reset()
                
                updateLabels(withInputValue: newBufferValue)
            } catch(let error) {
                handleCalculationError(error)
            }
        } else {
            currentOperation = PCOperation(bufferValue: inputValue, operatorType: operatorType)
            inputValue.reset()
        }
    }
    
    func calculateButtonDidPress() {
        guard let pendingOperation = currentOperation else { return }
        
        do {
            let calculatedValue = try calculateBinaryOperation(lhs: pendingOperation.bufferValue, rhs: inputValue, operatorType: pendingOperation.operatorType)
            
            currentOperation = nil
            inputValue = convert(calculatedValue, to: conversionSettings.inputSystem)
            
            updateLabels(withInputValue: inputValue)
        } catch(let error) {
            handleCalculationError(error)
        }
    }
    
    private func calculateUnaryOperation(_ pcNumber: PCNumber, operatorType: OperatorType) -> PCNumberInput {
        let bitWidth = wordSize.bitWidth
        let isSigned = calculatorState.processSigned
        
        let decimal = pcNumber.pcDecimalValue.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned)

        switch operatorType {
        case .oneS:
            return ~decimal
        case .twoS:
            return ~decimal + 1
        case .shiftLeft:
            return decimal << 1
        case .shiftRight:
            return decimal >> 1
        default:
            return decimal
        }
    }
    
    private func calculateBinaryOperation(lhs: PCNumber, rhs: PCNumber, operatorType: OperatorType) throws -> PCNumberInput {
        let bitWidth = wordSize.bitWidth
        let isSigned = calculatorState.processSigned
        
        let lhsDecimal = lhs.pcDecimalValue.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned)
        let rhsDecimal = rhs.pcDecimalValue.fixedOverflow(bitWidth: bitWidth, isSigned: isSigned)
        
        switch operatorType {
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
        default:
            return rhsDecimal
        }
    }
    
    private func handleCalculationError(_ error: Error) {
        currentOperation = nil
        inputValue.reset()
        
        calculatorPresenterDelegate.setInputLabelText(error.localizedDescription)
        calculatorPresenterDelegate.setOutputLabelText("NaN")
    }
    
    func getInputValueBits() -> [Bit] {
        let decimal = inputValue.pcDecimalValue.fixedOverflow(bitWidth: wordSize.bitWidth, isSigned: calculatorState.processSigned)
        let binary = PCBinary(pcDecimal: decimal)
        
        return binary.intPart.bits
    }
    
    func bitButtonDidPress(bitIsOn: Bool, atIndex bitIndex: UInt8) {
        let bit: UInt8 = bitIsOn ? 1 : 0
        
        let decimal = inputValue.pcDecimalValue.fixedOverflow(bitWidth: wordSize.bitWidth, isSigned: calculatorState.processSigned)
        var binary = PCBinary(pcDecimal: decimal)
        binary.switchBit(bit, atIndex: bitIndex)
        
        inputValue = convert(binary, to: conversionSettings.inputSystem)
        
        updateLabels(withInputValue: inputValue)
    }

    private func updateLabels(withInputValue inputValue: PCNumberInput) {
        let outputValue = convert(inputValue, to: conversionSettings.outputSystem)
        
        let bitWidth = wordSize.bitWidth
        let fractionalWidth = conversionSettings.fractionalWidth
        
        let inputText = inputValue.formattedInput(bitWidth: bitWidth)
        let outputText = outputValue.formattedOutput(bitWidth: bitWidth, fractionalWidth: fractionalWidth)
        
        calculatorPresenterDelegate.setInputLabelText(inputText)
        calculatorPresenterDelegate.setOutputLabelText(outputText)
    }
    
    private func convert<T: PCNumber>(_ pcNumber: T, to conversionSystem: ConversionSystem) -> PCNumberInput {
        let bitWidth = wordSize.bitWidth
        let isSigned = calculatorState.processSigned
        
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
