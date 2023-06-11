//
//  Calculator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorProtocol {
    var currentValue: PCDecimal { get set }
    var operation: Calculator.CalcOperation? { get set }
}

class Calculator: CalculatorProtocol {
    
    class CalcOperation {
        var current: CalcMath.OperationType
        var previousValue: PCDecimal?
        
        init(previousValue: PCDecimal, current: CalcMath.OperationType) {
            self.previousValue = previousValue
            self.current = current
        }
    }
    
    // MARK: - Properties
    
    var hasPendingOperation: Bool {
        if let operation = self.operation {
            return operation.current != .none
        } else {
            return false
        }
    }
    
    private let converter: Converter = Converter()
    private let calculationHandler: CalcMath = CalcMath()
    private let labelFormatter: LabelFormatter = LabelFormatter()
    
    weak var calculatorPresenterDelegate: CalculatorPresenterDelegate!

    let numberSystemFactory: NumberSystemFactory = NumberSystemFactory()
    let operationFactory: OperationFactory = OperationFactory()
    
    var currentValue: PCDecimal {
        didSet {
            print("PCDecimal new value: \(self.currentValue.getDecimal())")
            self.calcState.lastValue = self.currentValue
        }
    }
    
    var operation: CalcOperation?
    var shouldStartNewInput: Bool = true
    
    private let conversionSettings: ConversionSettings = ConversionSettings.shared
    private let calcState: CalcState = CalcState.shared
    private let wordSize: WordSize = WordSize.shared
    
    private let errorGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Initialization
    
    init() {
        self.currentValue = calcState.lastValue
    }
    
    // MARK: - Methods
    
    public func getOperation(with buttonText: String) -> CalcMath.OperationType {
        return self.operationFactory.get(buttonLabel: buttonText)
    }
    
    public func setOperation(_ operationType: CalcMath.OperationType) {
        self.operation = CalcOperation(previousValue: PCDecimal(value: self.currentValue.getDecimal()) , current: operationType)
    }
    
    public func setOperation(with buttonText: String) {
        let operationType = getOperation(with: buttonText)
        self.setOperation(operationType)
    }
    
    public func calculate(shouldStartNewInput: Bool = true) {
        guard self.operation != nil else { return }
        
        do {
            var result = try self.calculateCurrentValue()
            result.fixOverflow(bitWidth: self.wordSize.value, processSigned: self.calcState.processSigned)
            self.operation?.previousValue = PCDecimal(value: result.getDecimal())
            self.shouldStartNewInput = shouldStartNewInput
            self.currentValue = result
        } catch MathErrors.divByZero {
            self.resetCalculation()
            self.currentValue = PCDecimal(value: 0.0)
            self.setErrorInLabels(.divByZero)
            self.showErrorInLabels(.divByZero)
        } catch {
            
        }
    }
    
    private func showErrorInLabels(_ error: MathErrors) {
        calculatorPresenterDelegate.showErrorInLabels(error)
    }
    
    private func setErrorInLabels(_ error: MathErrors) {
        calculatorPresenterDelegate.setErrorInLabels(error)
    }
    
    func calculateCurrentValue() throws -> PCDecimal {
        guard let currentOperation = self.operation?.current else {
            return self.currentValue
        }

        // Unary operations
        switch currentOperation {
        case .oneS:
            return ~self.currentValue
        case .twoS:
            return ~self.currentValue + 1
        case .shiftLeft:
            return self.currentValue << 1
        case .shiftRight:
            return self.currentValue >> 1
        default:
            break
        }
        
        guard let previousValue = self.operation?.previousValue else {
            return self.currentValue
        }
        
        // Binary operations
        switch currentOperation {
        case .add:
            return previousValue + self.currentValue
        case .sub:
            return previousValue - self.currentValue
        case .mul:
            return previousValue * self.currentValue
        case .div:
            if self.currentValue != PCDecimal(0) {
                return previousValue / self.currentValue
            } else {
                throw MathErrors.divByZero
            }
        case .shiftLeftBy:
            return previousValue << self.currentValue
        case .shiftRightBy:
            return previousValue >> self.currentValue
        case .and:
            return previousValue & self.currentValue
        case .or:
            return previousValue | self.currentValue
        case .xor:
            return previousValue ^ self.currentValue
        case .nor:
            return ~(previousValue ^ self.currentValue)
        default:
            return self.currentValue
        }
    }
    
    public func negateCurrentValue() {
        self.currentValue = -self.currentValue
    }
    
    public func resetCurrentValue() {
        self.currentValue.updateValue(0.0)
    }
    
    public func updateCurrentValue(_ value: NumberSystemProtocol) {
        guard let decSystemValue = self.converter.convertValue(value: value, to: .dec, format: true) as? DecimalSystem else {
            return
        }
        self.currentValue.updateValue(decSystemValue.decimalValue)
    }
    
    public func getMainLabelValue() -> NumberSystemProtocol? {
        return converter.convertValue(value: self.currentValue, to: self.conversionSettings.systemMain, format: true)
    }
    
    public func getConvertedLabelValue() -> NumberSystemProtocol? {
        return converter.convertValue(value: self.currentValue, to: self.conversionSettings.systemConverter, format: true)
    }
    
    public func resetCalculation() {
        self.operation = nil
        self.shouldStartNewInput = true
    }
    
    public func mainLabelUpdate() {
        let mainLabelValue = self.getMainLabelValue()?.value ?? "0"
        let formattedText = self.labelFormatter.processStrInputToFormat(inputStr: mainLabelValue, for: self.conversionSettings.systemMain)
        calculatorPresenterDelegate.setMainLabelText(formattedText)
    }
    
    public func converterLabelUpdate() {
        let converterLabelValue = self.getConvertedLabelValue()?.value ?? "0"
        var formattedText = self.labelFormatter.processStrInputToFormat(inputStr: converterLabelValue, for: self.conversionSettings.systemConverter)
        let mainLabelLastDigitIsDot = calculatorPresenterDelegate.getMainLabelText(deleteSpaces: true).last == "."
        
        if mainLabelLastDigitIsDot && !formattedText.contains(".")  {
            formattedText.append(".")
        }
        calculatorPresenterDelegate.setConverterLabelText(formattedText)
    }
    
    public func mainLabelRemoveTrailing() {
        var mainLabelText = calculatorPresenterDelegate.getMainLabelText(deleteSpaces: false)
        
        if mainLabelText.count > 1 {
            mainLabelText.removeLast()
            if mainLabelText == "-" {
                mainLabelText = "0"
                calculatorPresenterDelegate.updateClearButton(hasInput: false)
            } else if mainLabelText.last == " " {
                mainLabelText.removeLast()
            }
        } else {
            mainLabelText = "0"
            calculatorPresenterDelegate.updateClearButton(hasInput: false)
        }

        if let numValue = numberSystemFactory.get(strValue: mainLabelText, currentSystem: conversionSettings.systemMain) {
            self.updateCurrentValue(numValue)
        }
        
        if mainLabelText.contains(".") {
            calculatorPresenterDelegate.setMainLabelText(mainLabelText)
        } else {
            self.mainLabelUpdate()
        }
        self.converterLabelUpdate()
    }
    
    public func mainLabelAdd(digit: String) {
        let labelText = calculatorPresenterDelegate.getMainLabelText(deleteSpaces: false)
        var newValue: String
        
        if calculatorPresenterDelegate.mainLabelHasError || self.shouldStartNewInput {
            newValue = digit == "." ? "0." : digit
            self.shouldStartNewInput = false
            calculatorPresenterDelegate.resetErrorInLabels()
        } else {
            newValue = self.labelFormatter.addDigitToMainLabel(labelText: labelText, digit: digit, currentValue: self.currentValue)
        }
        
        let formattedText = self.labelFormatter.processStrInputToFormat(inputStr: newValue, for: self.conversionSettings.systemMain)
        let newNumber = self.numberSystemFactory.get(strValue: formattedText, currentSystem: self.conversionSettings.systemMain)
        
        self.updateCurrentValue(newNumber!)
        calculatorPresenterDelegate.setMainLabelText(formattedText)
    }

    public func fixOverflowForCurrentValue() {
        self.currentValue.fixOverflow(bitWidth: self.wordSize.value, processSigned: self.calcState.processSigned)
    }
    
}
