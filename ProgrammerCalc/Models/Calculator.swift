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
    
    weak var calculatorPresenterDelegate: CalculatorPresenterDelegate!
    
    private let converter: Converter = Converter()
    private let calculationHandler: CalcMath = CalcMath()
    private let labelFormatter: LabelFormatter = LabelFormatter()

    let numberSystemFactory: NumberSystemFactory = NumberSystemFactory()
    let operationFactory: OperationFactory = OperationFactory()
    
    var operation: CalcOperation?
    var shouldStartNewInput: Bool = true
    
    var currentValue: PCDecimal {
        didSet {
            print("PCDecimal new value: \(currentValue.getDecimal())")
            calcState.lastValue = currentValue
        }
    }

    var hasPendingOperation: Bool {
        if let operation = self.operation {
            return operation.current != CalcMath.OperationType.none
        }
        return false
    }
    
    private let conversionSettings: ConversionSettings = ConversionSettings.shared
    private let calcState: CalcState = CalcState.shared
    private let wordSize: WordSize = WordSize.shared
    
    private let errorGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Initialization
    
    init() {
        currentValue = calcState.lastValue
    }
    
    // MARK: - Methods
    
    public func getOperation(with buttonText: String) -> CalcMath.OperationType {
        return operationFactory.get(buttonLabel: buttonText)
    }
    
    public func setOperation(_ operationType: CalcMath.OperationType) {
        operation = CalcOperation(previousValue: PCDecimal(value: currentValue.getDecimal()) , current: operationType)
    }
    
    public func setOperation(with buttonText: String) {
        let operationType = getOperation(with: buttonText)
        setOperation(operationType)
    }
    
    public func calculate(shouldStartNewInput startNewInput: Bool = true) {
        guard operation != nil else { return }
        
        do {
            var result = try calculateCurrentValue()
            result.fixOverflow(bitWidth: wordSize.intValue, processSigned: calcState.processSigned)
            operation?.previousValue = PCDecimal(value: result.getDecimal())
            shouldStartNewInput = startNewInput
            currentValue = result
        } catch MathError.divByZero {
            resetCalculation()
            currentValue = PCDecimal(value: 0.0)
            setErrorInLabels(.divByZero)
            showErrorInLabels(.divByZero)
        } catch {
  
        }
    }
    
    private func showErrorInLabels(_ error: MathError) {
        calculatorPresenterDelegate.showErrorInLabels(error)
    }
    
    private func setErrorInLabels(_ error: MathError) {
        calculatorPresenterDelegate.setErrorInLabels(error)
    }
    
    func calculateCurrentValue() throws -> PCDecimal {
        guard let currentOperation = operation?.current else {
            return currentValue
        }

        // Unary operations
        switch currentOperation {
        case .oneS:
            return ~currentValue
        case .twoS:
            return ~currentValue + 1
        case .shiftLeft:
            return currentValue << 1
        case .shiftRight:
            return currentValue >> 1
        default:
            break
        }
        
        guard let previousValue = operation?.previousValue else {
            return currentValue
        }
        
        // Binary operations
        switch currentOperation {
        case .add:
            return previousValue + currentValue
        case .sub:
            return previousValue - currentValue
        case .mul:
            return previousValue * currentValue
        case .div:
            if currentValue != .zero {
                return previousValue / currentValue
            } else {
                throw MathError.divByZero
            }
        case .shiftLeftBy:
            return previousValue << currentValue
        case .shiftRightBy:
            return previousValue >> currentValue
        case .and:
            return previousValue & currentValue
        case .or:
            return previousValue | currentValue
        case .xor:
            return previousValue ^ currentValue
        case .nor:
            return ~(previousValue ^ currentValue)
        default:
            return currentValue
        }
    }
    
    public func negateCurrentValue() {
        currentValue = -currentValue
    }
    
    public func resetCurrentValue() {
        currentValue.updateValue(0.0)
    }
    
    public func updateCurrentValue(_ value: NumberSystemProtocol) {
        guard let decSystemValue = converter.convertValue(value: value, to: .dec, format: true) as? DecimalSystem else {
            return
        }
        currentValue.updateValue(decSystemValue.decimalValue)
    }
    
    public func getMainLabelValue() -> NumberSystemProtocol? {
        return converter.convertValue(value: currentValue, to: conversionSettings.systemMain, format: true)
    }
    
    public func getConvertedLabelValue() -> NumberSystemProtocol? {
        return converter.convertValue(value: currentValue, to: conversionSettings.systemConverter, format: true)
    }
    
    public func resetCalculation() {
        operation = nil
        shouldStartNewInput = true
    }
    
    public func mainLabelUpdate() {
        let mainLabelValue = getMainLabelValue()?.value ?? "0"
        let formattedText = labelFormatter.processStrInputToFormat(inputStr: mainLabelValue, for: conversionSettings.systemMain)
        calculatorPresenterDelegate.setMainLabelText(formattedText)
    }
    
    public func converterLabelUpdate() {
        let converterLabelValue = getConvertedLabelValue()?.value ?? "0"
        var formattedText = labelFormatter.processStrInputToFormat(inputStr: converterLabelValue, for: conversionSettings.systemConverter)
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
            updateCurrentValue(numValue)
        }
        
        if mainLabelText.contains(".") {
            calculatorPresenterDelegate.setMainLabelText(mainLabelText)
        } else {
            mainLabelUpdate()
        }
        converterLabelUpdate()
    }
    
    public func mainLabelAdd(digit: String) {
        let labelText = calculatorPresenterDelegate.getMainLabelText(deleteSpaces: false)
        var newValue: String
        
        if calculatorPresenterDelegate.mainLabelHasError || shouldStartNewInput {
            newValue = digit == "." ? "0." : digit
            self.shouldStartNewInput = false
            calculatorPresenterDelegate.resetErrorInLabels()
        } else {
            newValue = labelFormatter.addDigitToMainLabel(labelText: labelText, digit: digit, currentValue: currentValue)
        }
        
        let formattedText = labelFormatter.processStrInputToFormat(inputStr: newValue, for: conversionSettings.systemMain)
        if let newNumber = numberSystemFactory.get(strValue: formattedText, currentSystem: conversionSettings.systemMain) {
            updateCurrentValue(newNumber)
            calculatorPresenterDelegate.setMainLabelText(formattedText)
        }
    }

    public func fixOverflowForCurrentValue() {
        currentValue.fixOverflow(bitWidth: wordSize.intValue, processSigned: calcState.processSigned)
    }
}
