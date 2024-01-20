//
//  SettingsPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol SettingsOutput: AnyObject {
    var updateHandler: (() -> Void)? { get set }
    func obtainSettings()
    func updateTappingSounds(_ state: Bool)
    func updateHapticFeedback(_ state: Bool)
    func saveSettings()
    func openAppearance()
    func openAbout()
}

final class SettingsPresenter: SettingsOutput {
    
    // MARK: - Properties
    
    weak var view: SettingsInput!

    var updateHandler: (() -> Void)?
    
    var storage: CalculatorStorage!
    var settings: Settings!
    
    // MARK: - Methods
    
    func obtainSettings() {
        let loadedSettings: Settings = storage.loadData()
        settings.set(loadedSettings)
        
        view.setTappingSoundsPreferenceModelSwitch(isOn: settings.isTappingSoundsEnabled)
        view.setHapticFeedbackPreferenceModelSwitch(isOn: settings.isHapticFeedbackEnabled)
    }
    
    func updateTappingSounds(_ isEnabled: Bool) {
        settings.isTappingSoundsEnabled = isEnabled
        saveSettings()
    }
    
    func updateHapticFeedback(_ isEnabled: Bool) {
        settings.isHapticFeedbackEnabled = isEnabled
        saveSettings()
    }
    
    func saveSettings() {
        storage.saveData(settings)
    }
    
    func openAppearance() {
        let appearanceView = AppearanceModuleAssembly.configureModule()
        view.push(appearanceView)
    }
    
    func openAbout() {
        let aboutView = AboutModuleAssembly.conigureModule()
        view.push(aboutView)
    }
}
