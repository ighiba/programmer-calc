//
//  CalculatorPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorPresenterDelegate: AnyObject {
    var mainLabelHasError: Bool { get }
    func clearLabels()
    func updateAllLayout()
    func updateClearButton(hasInput: Bool)
    func showErrorInLabels(_ error: MathErrors)
    func setErrorInLabels(_ error: MathErrors)
    func resetErrorInLabels()
    func getMainLabelText(deleteSpaces: Bool) -> String
    func setMainLabelText(_ text: String)
    func setConverterLabelText(_ text: String)
}

protocol CalculatorInput: AnyObject {
    func clearLabels()
//    func unhighlightLabels()
    func updateAllLayout()
    func updateClearButton(hasInput: Bool)
    func mainLabelHasError() -> Bool
    func showErrorInLabels(_ error: MathErrors)
    func setErrorInLabels(_ error: MathErrors)
    func resetErrorInLabels()
    func getMainLabelText(deleteSpaces: Bool) -> String
    func setMainLabelText(_ text: String)
    func setConverterLabelText(_ text: String)
    func updateAfterConversionChange()
    func presentViewControlle(_ viewController: UIViewController, animated: Bool)
}

protocol CalculatorOutput: AnyObject {
    func getMainSystem() -> ConversionSystem
    func getConverterSystem() -> ConversionSystem
    func isInvalidMainLabelInput(_ text: String) -> Bool
    func resetCurrentValueAndUpdateLabels()
    func updateMainLabelWithCurrentValue()
    func updateConverterLabelWithCurrentValue()
    func getForbiddenToInputDigits() -> Set<String>
    func isProcessSigned() -> Bool
    func mainLabelAddAndUpdate(digit: String)
    func mainLabelRemoveTrailing()
    func getCurrentValueBinary(format: Bool) -> Binary?
    func setNewCurrentValue(_ value: NumberSystemProtocol)
    func doOperationFor(operationString: String)
    func toggleProcessSigned()
    func resetCalculation()
    func doCalculation()
    func doNegation()
    func fixOverflowForCurrentValue()
    
    func showConversion()
    func showWordSize()
    func showSettings()
}

class CalculatorPresenter: CalculatorOutput {
    
    weak var input: CalculatorInput!
    
    var calculator: Calculator!
    var converter: Converter!
    
    var storage: CalculatorStorage!
    
    private let conversionSettings = ConversionSettings.shared
    private let calcState = CalcState.shared
    
    init() {
        
    }
    
    // MARK: - Methods
    
    func getMainSystem() -> ConversionSystem {
        return conversionSettings.systemMain
    }
    
    func getConverterSystem() -> ConversionSystem {
        return conversionSettings.systemConverter
    }
    
    func isInvalidMainLabelInput(_ text: String) -> Bool {
        if ConversionValues.getForbidden(for: conversionSettings.systemMain).contains(where: text.contains) {
            print("Forbidden values at input")
            return true
        }
        return false
    }
    
    func resetCurrentValueAndUpdateLabels() {
        calculator.resetCurrentValue()
        updateLabels()
    }
    
    private func mainLabelUpdate() {
        calculator.mainLabelUpdate()
    }
    
    private func converterLabelUpdate() {
        calculator.converterLabelUpdate()
    }
    
    func updateMainLabelWithCurrentValue() {
        calculator.mainLabelUpdate()
    }
    
    func updateConverterLabelWithCurrentValue() {
        calculator.converterLabelUpdate()
    }
    
    func getForbiddenToInputDigits() -> Set<String> {
        return ConversionValues.getForbidden(for: conversionSettings.systemMain)
    }
    
    func isProcessSigned() -> Bool {
        return calcState.processSigned
    }
    
    func mainLabelAddAndUpdate(digit: String) {
        calculator.mainLabelAdd(digit: digit)
    }
    
    func mainLabelRemoveTrailing() {
        calculator.mainLabelRemoveTrailing()
    }
    
    func getCurrentValueBinary(format: Bool) -> Binary? {
        return converter.convertValue(value: calculator.currentValue, to: .bin, format: false) as? Binary
    }
    
    func setNewCurrentValue(_ value: NumberSystemProtocol) {
        let dec = converter.convertValue(value: value, to: .dec, format: true) as! DecimalSystem
        calculator.currentValue.updateValue(dec.decimalValue)
    }
    
    func doOperationFor(operationString: String) {
        let operation = calculator.getOperation(with: operationString)
        guard operation != .none else { return }
        
        if calculator.hasPendingOperation && calculator.shouldStartNewInput {
            calculator.setOperation(operation)
            return
        } else if calculator.hasPendingOperation {
            calculator.calculate()
            calculator.setOperation(operation)
            updateLabels()
        } else if isUnaryOperation(operation) {
            calculator.setOperation(operation)
            calculator.calculate()
            calculator.resetCalculation()
            calculator.shouldStartNewInput = true
            updateLabels()
        } else {
            calculator.setOperation(operation)
            calculator.shouldStartNewInput = true
        }
    }
    
    private func isUnaryOperation(_ operation: CalcMath.OperationType) -> Bool {
        return operation == .shiftRight ||
               operation == .shiftLeft ||
               operation == .oneS ||
               operation == .twoS
    }
    
    private func updateLabels() {
        mainLabelUpdate()
        converterLabelUpdate()
    }
    
    func toggleProcessSigned() {
        let valueIsNegativeAndWillProcessUnsigned = isValueIsNegativeAndWillProcessUnsigned()
        let valueIsPositiveAndWillProcessSigned =  isValueIsPositiveAndWillProcessSigned()
        
        calcState.processSigned.toggle()

        if valueIsNegativeAndWillProcessUnsigned || valueIsPositiveAndWillProcessSigned {
            let oldValue = calculator.currentValue
            calculator.currentValue.fixOverflow(bitWidth: WordSize.shared.intValue, processSigned: calcState.processSigned)
            
            if calculator.currentValue.isSignedAndFloat {
                input.clearLabels()
            } else if oldValue != calculator.currentValue {
                updateLabels()
            }
        }
    }
    
    private func isValueIsNegativeAndWillProcessUnsigned() -> Bool {
        return calculator.currentValue.isSigned && (calcState.processSigned == true)
    }
    
    private func isValueIsPositiveAndWillProcessSigned() -> Bool {
        return !calculator.currentValue.isSigned && (calcState.processSigned == false)
    }
    
    func resetCalculation() {
        calculator.resetCalculation()
    }
    
    func doCalculation() {
        if calculator.hasPendingOperation {
            calculator.calculate()
            calculator.resetCalculation()
            
            guard !input.mainLabelHasError() else { return }
            updateLabels()
        }
    }
    
    func doNegation() {
        if calculator.currentValue.hasFloatingPoint {
            return
        }
        calculator.negateCurrentValue()
        updateLabels()
    }
    
    func fixOverflowForCurrentValue() {
        calculator.fixOverflowForCurrentValue()
    }
    
    func showConversion() {
        guard let conversionView = ConversionModuleAssembly.configureModule() as? ConversionViewController else {
            return
        }
        conversionView.modalPresentationStyle = .overFullScreen
        conversionView.output.delegate = self
        conversionView.output.updateHandler = { [weak self] in
            self?.input.updateAfterConversionChange()
        }
        input.presentViewControlle(conversionView, animated: false)
    }
    
    func showWordSize() {
        guard let wordSizeView = WordSizeModuleAssembly.configureModule() as? WordSizeViewController else {
            return
        }
        wordSizeView.modalPresentationStyle = .overFullScreen
        wordSizeView.output.updateHandler = { [weak self] in
            self?.fixOverflowForCurrentValue()
            self?.input.updateAllLayout()
        }
        input.presentViewControlle(wordSizeView, animated: false)
    }
    
    func showSettings() {
        guard let settingsView = SettingsModuleAssembly.configureModule() as? SettingsViewController else {
            return
        }
        let navigationController = UINavigationController()
        settingsView.modalPresentationStyle = .pageSheet
        navigationController.presentationController?.delegate = input as? UIAdaptivePresentationControllerDelegate
        settingsView.output.updateHandler = { [weak self] in
            self?.input.updateAllLayout()
        }
        navigationController.setViewControllers([settingsView], animated: false)
        input.presentViewControlle(navigationController, animated: true)
    }
    
}

// MARK: - Delegate

extension CalculatorPresenter: CalculatorPresenterDelegate {
    var mainLabelHasError: Bool {
        return input.mainLabelHasError()
    }
    
    func clearLabels() {
        input.clearLabels()
    }
    
    func updateAllLayout() {
        input.updateAllLayout()
    }
    
    func updateClearButton(hasInput: Bool) {
        input.updateClearButton(hasInput: hasInput)
    }
    
    func showErrorInLabels(_ error: MathErrors) {
        input.showErrorInLabels(error)
    }
    
    func setErrorInLabels(_ error: MathErrors) {
        input.setErrorInLabels(error)
    }
    
    func resetErrorInLabels() {
        input.resetErrorInLabels()
    }
    
    func getMainLabelText(deleteSpaces: Bool) -> String {
        return input.getMainLabelText(deleteSpaces: deleteSpaces)
    }
    
    func setMainLabelText(_ text: String) {
        input.setMainLabelText(text)
    }
    
    func setConverterLabelText(_ text: String) {
        input.setConverterLabelText(text)
    }
}
