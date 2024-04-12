//
//  CalculatorPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol CalculatorPresenterDelegate: AnyObject {
    func setInputLabelText(_ text: String)
    func setOutputLabelText(_ text: String)
}

protocol CalculatorOutput: AnyObject {
    func viewDidLoad()
    func clearButtonDidPress()
    func labelDidSwipeRight()
    func negateButtonDidPress()
    func signedButtonDidPress()
    func numericButtonDidPress(digit: NumericButton.Digit)
    func dotButtonDidPress()
    func complementButtonDidPress(complementOperator: ComplementOperator)
    func operatorButtonDidPress(operatorType: OperatorButton.OperatorType)
    func calculateButtonDidPress()
    func getInputValueBits() -> [Bit]
    func bitButtonDidPress(bitIsOn: Bool, atIndex bitIndex: UInt8)
    func didEnterPhonePortraitOrientation()
    func didEnterPhoneLandscapeOrientation(isBitwiseKeypadActive: Bool)
    func showConversion()
    func showWordSize()
    func showSettings()
}

final class CalculatorPresenter: CalculatorOutput {
    
    // MARK: - Properties
    
    weak var input: CalculatorInput!
    
    private let calculator: Calculator
    
    private let wordSize: WordSize
    private let calculatorState: CalculatorState
    private let conversionSettings: ConversionSettings
    
    // MARK: - Init
    
    init(calculator: Calculator, wordSize: WordSize, calculatorState: CalculatorState, conversionSettings: ConversionSettings) {
        self.calculator = calculator
        self.wordSize = wordSize
        self.calculatorState = calculatorState
        self.conversionSettings = conversionSettings
    }
    
    // MARK: - Methods
    
    func viewDidLoad() {
        calculator.load()
        updateWordSizeButtonTitle()
        updateConversionSystemTitles()
        updateNumericButtonsIsEnabled()
        updateSignedButtons()
    }

    func clearButtonDidPress() {
        calculator.clearButtonDidPress()
        input.changeClearButtonTitle(inputState: .inputNotStarted)
    }
    
    func labelDidSwipeRight() {
        calculator.removeLeastSignificantDigit()
        updateBitwiseKeypad()
    }
    
    func negateButtonDidPress() {
        calculator.negateInputValue()
    }
    
    func signedButtonDidPress() {
        calculatorState.isSigned.toggle()
        updateSignedButtons()
        calculator.reload()
    }

    func numericButtonDidPress(digit: NumericButton.Digit) {
        calculator.numericButtonDidPress(digit: digit)
        input.changeClearButtonTitle(inputState: .inputStarted)
    }
    
    func dotButtonDidPress() {
        calculator.dotButtonDidPress()
        input.changeClearButtonTitle(inputState: .inputStarted)
    }
    
    func complementButtonDidPress(complementOperator: ComplementOperator) {
        calculator.complementButtonDidPress(complementOperator: complementOperator)
    }
    
    func operatorButtonDidPress(operatorType: OperatorButton.OperatorType) {
        switch operatorType {
        case .unary(let unaryOperator):
            calculator.unaryOperatorButtonDidPress(unaryOperator: unaryOperator)
        case .binary(let binaryOperator):
            calculator.binaryOperatorButtonDidPress(binaryOperator: binaryOperator)
        }
    }
    
    func calculateButtonDidPress() {
        calculator.calculateButtonDidPress()
    }
    
    func getInputValueBits() -> [Bit] {
        calculator.getInputValueBits()
    }

    func bitButtonDidPress(bitIsOn: Bool, atIndex bitIndex: UInt8) {
        calculator.bitButtonDidPress(bitIsOn: bitIsOn, atIndex: bitIndex)
    }
    
    func didEnterPhonePortraitOrientation() {
        updateLabelsDisplayMode()
    }
    
    func didEnterPhoneLandscapeOrientation(isBitwiseKeypadActive: Bool) {
        let inputNumberOfLines = conversionSettings.inputSystem == .bin ? 2 : 1

        if isBitwiseKeypadActive {
            let displayMode: CalculatorLabelsDisplayMode = .onlyInputLabel(numberOfLines: inputNumberOfLines)
            input.setLabelsDisplayMode(displayMode)
        }
    }
    
    func showConversion() {
        guard let conversionView = ConversionModuleAssembly.configureModule() as? ConversionViewController else { return }
        
        conversionView.modalPresentationStyle = .overFullScreen
        conversionView.presenter.updateHandler = { [weak self] in
            self?.calculator.reload()
            self?.updateConversionSystemTitles()
            self?.updateNumericButtonsIsEnabled()
            self?.updateLabelsDisplayMode()
            self?.updateBitwiseKeypad()
        }
        
        input.presentViewController(conversionView, animated: false)
    }

    func showWordSize() {
        guard let wordSizeView = WordSizeModuleAssembly.configureModule() as? WordSizeViewController else { return }
        
        wordSizeView.modalPresentationStyle = .overFullScreen
        wordSizeView.output.updateHandler = { [weak self] in
            self?.calculator.reload()
            self?.updateWordSizeButtonTitle()
            self?.updateBitwiseKeypad()
        }
        
        input.presentViewController(wordSizeView, animated: false)
    }
    
    func showSettings() {
        guard let settingsView = SettingsModuleAssembly.configureModule() as? SettingsViewController else { return }
        
        let navigationController = UINavigationController()
        settingsView.modalPresentationStyle = .pageSheet
        navigationController.presentationController?.delegate = input as? UIAdaptivePresentationControllerDelegate
        navigationController.setViewControllers([settingsView], animated: false)
        
        input.presentViewController(navigationController, animated: true)
    }
    
    private func updateWordSizeButtonTitle() {
        input.setWordSizeButtonTitle(wordSize.value.title)
    }
    
    private func updateConversionSystemTitles() {
        let inputConversionSystemTitle = conversionSettings.inputSystem.title
        let outputConversionSystemTitle = conversionSettings.outputSystem.title
        
        input.setInputConversionSystemLabelText(inputConversionSystemTitle)
        input.setOutputConversionSystemLabelText(outputConversionSystemTitle)
    }
    
    private func updateNumericButtonsIsEnabled() {
        let forbiddenDigits = ConversionValues.getForbidden(for: conversionSettings.inputSystem)
        input.disableNumericButtons(withForbiddenDigits: forbiddenDigits)
    }
    
    private func updateSignedButtons() {
        let isSigned = calculatorState.isSigned
        let signedState: SignedButton.State = isSigned ? .on : .off
        input.setNegateButton(isEnabled: isSigned)
        input.changeSignedButtonTitle(signedState: signedState)
    }
    
    private func updateLabelsDisplayMode() {
        let inputNumberOfLines = conversionSettings.inputSystem == .bin ? 2 : 1
        let outputNumberOfLines = conversionSettings.outputSystem == .bin ? 2 : 1
        
        let displayMode: CalculatorLabelsDisplayMode
        if conversionSettings.inputSystem == conversionSettings.outputSystem {
            displayMode = .onlyInputLabel(numberOfLines: inputNumberOfLines)
        } else {
            displayMode = .standart(inputNumberOfLines: inputNumberOfLines, outputNumberOfLines: outputNumberOfLines)
        }
        
        input.setLabelsDisplayMode(displayMode)
    }
    
    private func updateBitwiseKeypad() {
        let bits = calculator.getInputValueBits()
        input.updateBitwiseKeypad(withBits: bits)
    }
}

// MARK: - Delegate

extension CalculatorPresenter: CalculatorPresenterDelegate {
    
    func setInputLabelText(_ text: String) {
        input.setInputLabelText(text)
    }
    
    func setOutputLabelText(_ text: String) {
        input.setOutputLabelText(text)
    }
}
