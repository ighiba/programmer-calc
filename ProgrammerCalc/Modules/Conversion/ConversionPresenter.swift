//
//  ConversionPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol ConversionOutput: AnyObject {
    func updateView()
    func saveConversionSettings(inputPickerSelectedRow: Int, outputPickerSelectedRow: Int, sliderValue: Float)
    func sliderValueDidChange(_ sliderValue: Float)
}

final class ConversionPresenter: ConversionOutput {
    
    // MARK: - Properties
    
    weak var view: ConversionInput!
    
    private let conversionSettings: ConversionSettings
    private let settings: Settings
    private let storage: CalculatorStorage
    
    private var conversionSettingsDidUpdate: (() -> Void)?
    
    // MARK: - Init
    
    init(conversionSettings: ConversionSettings, settings: Settings, storage: CalculatorStorage, conversionSettingsDidUpdate: (() -> Void)? = nil) {
        self.conversionSettings = conversionSettings
        self.settings = settings
        self.storage = storage
        self.conversionSettingsDidUpdate = conversionSettingsDidUpdate
    }
    
    // MARK: - Methods
    
    func updateView() {
        let inputSystemRowIndex = conversionSettings.inputSystem.rawValue
        let outputSystemRowIndex = conversionSettings.outputSystem.rawValue
        let fractionalWidth = Int(conversionSettings.fractionalWidth)
        let sliderValue = Float(conversionSettings.fractionalWidth) / 4
        
        view.inputPickerSelectRow(atIndex: inputSystemRowIndex)
        view.outputPickerSelectRow(atIndex: outputSystemRowIndex)
        view.setFractionalWidthLabelValue(fractionalWidth)
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

        conversionSettingsDidUpdate?()
    }
    
    func sliderValueDidChange(_ sliderValue: Float) {
        if settings.isHapticFeedbackEnabled {
            view.hapticImpact()
        }
        
        let value = Int(sliderValue) * 4
        view.setFractionalWidthLabelValue(value)
    }
}
