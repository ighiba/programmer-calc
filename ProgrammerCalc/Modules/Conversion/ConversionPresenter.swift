//
//  ConversionPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol ConversionInput: AnyObject {
    func mainPickerSelect(row: Int)
    func converterPickerSelect(row: Int)
    func setLabelValueText(_ text: String)
    func setSliderValue(_ value: Float)
    func hapticImpact()
}

protocol ConversionOutput: AnyObject {
    var delegate: CalculatorPresenterDelegate! { get set }
    var updateHandler: (() -> Void)? { get set }
    func obtainConversionSettings()
    func saveConversionSettings(mainRow: Int, converterRow: Int, sliderValue: Float)
    func sliderValueDidChanged(_ sliderValue: Float)
}

class ConversionPresenter: ConversionOutput {
    
    // MARK: - Properties
    
    weak var view: ConversionInput!
    
    weak var delegate: CalculatorPresenterDelegate!
    var updateHandler: (() -> Void)?

    var storage: CalculatorStorage!
    
    var conversionSettings: ConversionSettings!
    var settings: Settings!
    
    // MARK: - Methods
    
    func obtainConversionSettings() {
        let mainRow: Int = ConversionSystemsEnum.allCases.firstIndex(of: conversionSettings.systemMain) ?? 1 // default decimal for main
        let converterRow: Int = ConversionSystemsEnum.allCases.firstIndex(of: conversionSettings.systemConverter) ?? 0 // default binary for converter
        view.mainPickerSelect(row: mainRow)
        view.converterPickerSelect(row: converterRow)
        view.setLabelValueText("\(Int(conversionSettings.numbersAfterPoint))")
        view.setSliderValue(Float(conversionSettings.numbersAfterPoint) / 4)
    }
    
    func saveConversionSettings(mainRow: Int, converterRow: Int, sliderValue: Float) {
        let mainSystemNew = ConversionSystemsEnum(rawValue: mainRow)!
        let converterSystemNew = ConversionSystemsEnum(rawValue: converterRow)!
        
        let newConversionSettings = ConversionSettings(
            systMain: mainSystemNew,
            systConverter: converterSystemNew,
            number: Int(sliderValue) * 4
        )
        
        let mainSystemOld = conversionSettings.systemMain
        
        storage.saveData(newConversionSettings)
        conversionSettings.setConversionSettings(newConversionSettings)

        if mainSystemOld != mainSystemNew {
            delegate!.clearLabels()
        } else {
            delegate!.updateAllLayout()
        }
        
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
