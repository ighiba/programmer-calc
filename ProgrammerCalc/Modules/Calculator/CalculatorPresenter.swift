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
    func numericButtonDidPress(digit: Character)
    func dotButtonDidPress()
    func operatorButtonDidPress(operatorString: String)
    func calculateButtonDidPress()
    func getInputValueBits() -> [Bit]
    func bitButtonDidPress(bitIsOn: Bool, atIndex bitIndex: UInt8)
    func didEnterPhonePortraitOrientation()
    func didEnterPhoneLandscapeOrientation(isBitwiseKeypadActive: Bool)
    func showConversion()
    func showWordSize()
    func showSettings()
}

class CalculatorPresenter: CalculatorOutput {
    
    // MARK: - Properties
    
    weak var input: CalculatorInput!
    
    var calculator: Calculator!
    var operatorFactory: OperatorFactory!
    
    var wordSize: WordSize!
    var calculatorState: CalculatorState!
    var conversionSettings: ConversionSettings!
    
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
        input.setClearButtonTitle(inputHasStarted: false)
    }
    
    func labelDidSwipeRight() {
        calculator.removeLeastSignificantDigit()
        updateBitwiseKeypad()
    }
    
    func negateButtonDidPress() {
        calculator.negateInputValue()
    }
    
    func signedButtonDidPress() {
        calculatorState.processSigned.toggle()
        updateSignedButtons()
        calculator.reload()
    }

    func numericButtonDidPress(digit: Character) {
        calculator.numericButtonDidPress(digit: digit)
        input.setClearButtonTitle(inputHasStarted: true)
    }
    
    func dotButtonDidPress() {
        calculator.dotButtonDidPress()
        input.setClearButtonTitle(inputHasStarted: true)
    }
    
    func operatorButtonDidPress(operatorString: String) {
        let operatorType = operatorFactory.get(byStringValue: operatorString)

        if operatorType.isUnaryOperator {
            calculator.unaryOperatorButtonDidPress(operatorType: operatorType)
        } else {
            calculator.binaryOperatorButtonDidPress(operatorType: operatorType)
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
        let inputNumberOfLines = conversionSettings.systemMain == .bin ? 2 : 1

        if isBitwiseKeypadActive {
            let displayMode: CalculatorLabelsDisplayMode = .onlyInputLabel(numberOfLines: inputNumberOfLines)
            input.setLabelsDisplayMode(displayMode)
        }
    }
    
    func showConversion() {
        guard let conversionView = ConversionModuleAssembly.configureModule() as? ConversionViewController else { return }
        
        conversionView.modalPresentationStyle = .overFullScreen
        conversionView.output.delegate = self
        conversionView.output.updateHandler = { [weak self] in
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
        let inputConversionSystemTitle = conversionSettings.systemMain.title
        let outputConversionSystemTitle = conversionSettings.systemConverter.title
        
        input.setInputConversionSystemLabelText(inputConversionSystemTitle)
        input.setOutputConversionSystemLabelText(outputConversionSystemTitle)
    }
    
    private func updateNumericButtonsIsEnabled() {
        let forbiddenDigits = ConversionValues.getForbidden(for: conversionSettings.systemMain)
        input.disableNumericButtons(withForbiddenDigits: forbiddenDigits)
    }
    
    private func updateSignedButtons() {
        let isSigned = calculatorState.processSigned
        input.setNegateButton(isEnabled: isSigned)
        input.changeSignedButtonLabel(isSigned: isSigned)
    }
    
    private func updateLabelsDisplayMode() {
        let inputNumberOfLines = conversionSettings.systemMain == .bin ? 2 : 1
        let outputNumberOfLines = conversionSettings.systemConverter == .bin ? 2 : 1
        
        let displayMode: CalculatorLabelsDisplayMode
        if conversionSettings.systemMain == conversionSettings.systemConverter {
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
