//
//  ConversionPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol ConversionOutput: AnyObject {
    var updateHandler: (() -> Void)? { get set }
    func updateView()
    func saveConversionSettings(inputPickerSelectedRow: Int, outputPickerSelectedRow: Int, sliderValue: Float)
    func sliderValueDidChange(_ sliderValue: Float)
}

final class ConversionPresenter: ConversionOutput {
    
    // MARK: - Properties
    
    weak var view: ConversionInput!
    
    var updateHandler: (() -> Void)?
    
    private let conversionSettings: ConversionSettings
    private let settings: Settings
    private let storage: CalculatorStorage
    
    // MARK: - Init
    
    init(conversionSettings: ConversionSettings, settings: Settings, storage: CalculatorStorage) {
        self.conversionSettings = conversionSettings
        self.settings = settings
        self.storage = storage
    }
    
    // MARK: - Methods
    
    func updateView() {
        let inputSystemRowIndex = conversionSettings.inputSystem.rawValue
        let outputSystemRowIndex = conversionSettings.outputSystem.rawValue
        let sliderValueText = "\(conversionSettings.fractionalWidth)"
        let sliderValue = Float(conversionSettings.fractionalWidth) / 4
        
        view.inputPickerSelectRow(atIndex: inputSystemRowIndex)
        view.outputPickerSelectRow(atIndex: outputSystemRowIndex)
        view.setFractionalWidthLabelText(sliderValueText)
        view.setFractionalWidthSliderValue(sliderValue)
    }
    
    func saveConversionSettings(inputPickerSelectedRow: Int, outputPickerSelectedRow: Int, sliderValue: Float) {
        guard let inputSystemNew = ConversionSystem(rawValue: inputPickerSelectedRow),
              let outputSystemNew = ConversionSystem(rawValue: outputPickerSelectedRow)
        else {
            return
        }
        
        let newConversionSettings = ConversionSettings(
            inputSystem: inputSystemNew,
            outputSystem: outputSystemNew,
            fractionalWidth: UInt8(sliderValue * 4)
        )
        
        storage.saveData(newConversionSettings)
        conversionSettings.set(newConversionSettings)

        updateHandler?()
    }
    
    func sliderValueDidChange(_ sliderValue: Float) {
        if settings.isHapticFeedbackEnabled {
            view.hapticImpact()
        }
        
        let text = "\(Int(sliderValue) * 4)"
        view.setFractionalWidthLabelText(text)
    }
}
