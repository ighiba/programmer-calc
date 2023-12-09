//
//  ConversionPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol ConversionInput: AnyObject {
    func inputPickerSelect(row: Int)
    func outputPickerSelect(row: Int)
    func setLabelValueText(_ text: String)
    func setSliderValue(_ value: Float)
    func hapticImpact()
}

protocol ConversionOutput: AnyObject {
    var delegate: CalculatorPresenterDelegate! { get set }
    var updateHandler: (() -> Void)? { get set }
    func obtainConversionSettings()
    func saveConversionSettings(inputSystemRow: Int, outputSystemRow: Int, sliderValue: Float)
    func sliderValueDidChanged(_ sliderValue: Float)
}

final class ConversionPresenter: ConversionOutput {
    
    // MARK: - Properties
    
    weak var view: ConversionInput!
    
    weak var delegate: CalculatorPresenterDelegate!
    var updateHandler: (() -> Void)?

    var storage: CalculatorStorage!
    
    var conversionSettings: ConversionSettings!
    var settings: Settings!
    
    // MARK: - Methods
    
    func obtainConversionSettings() {
        let inputSystemRow = ConversionSystem.allCases.firstIndex(of: conversionSettings.inputSystem) ?? 1 // default decimal for input
        let outputSystemRow = ConversionSystem.allCases.firstIndex(of: conversionSettings.outputSystem) ?? 0 // default binary for output
        view.inputPickerSelect(row: inputSystemRow)
        view.outputPickerSelect(row: outputSystemRow)
        view.setLabelValueText("\(conversionSettings.fractionalWidth)")
        view.setSliderValue(Float(conversionSettings.fractionalWidth) / 4)
    }
    
    func saveConversionSettings(inputSystemRow: Int, outputSystemRow: Int, sliderValue: Float) {
        let inputSystemNew = ConversionSystem(rawValue: inputSystemRow)!
        let outputSystemNew = ConversionSystem(rawValue: outputSystemRow)!
        
        let newConversionSettings = ConversionSettings(
            inputSystem: inputSystemNew,
            outputSystem: outputSystemNew,
            fractionalWidth: UInt8(sliderValue * 4)
        )
        
        storage.saveData(newConversionSettings)
        conversionSettings.setConversionSettings(newConversionSettings)

        updateHandler?()
    }
    
    func sliderValueDidChanged(_ sliderValue: Float) {
        if settings.hapticFeedback {
            view.hapticImpact()
        }
        let textValue = "\(Int(sliderValue) * 4)"
        view.setLabelValueText(textValue)
    }
}
