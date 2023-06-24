//
//  SettingsPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol SettingsInput: AnyObject {
    func reloadTable()
    func setTappingSoundsSwitcherState(_ isOn: Bool)
    func setHapticFeedbackSwitcherState(_ isOn: Bool)
    func push(_ viewController: UIViewController)
}

protocol SettingsOutput: AnyObject {
    var updateHandler: (() -> Void)? { get set }
    func obtainSettings()
    func updateTappingSounds(_ state: Bool)
    func updateHapticFeedback(_ state: Bool)
    func saveSettings()
    func openAppearance()
    func openAbout()
}

class SettingsPresenter: SettingsOutput {
    
    // MARK: - Properties
    
    weak var view: SettingsInput!

    var updateHandler: (() -> Void)?
    
    var storage: CalculatorStorage!
    var settings: Settings!
    
    // MARK: - Methods
    
    func obtainSettings() {
        let loadedSettings: Settings = storage.loadData()
        settings.setSettings(loadedSettings)
        
        view.setTappingSoundsSwitcherState(settings.tappingSounds)
        view.setHapticFeedbackSwitcherState(settings.hapticFeedback)
    }
    
    func updateTappingSounds(_ state: Bool) {
        settings.tappingSounds = state
        saveSettings()
    }
    
    func updateHapticFeedback(_ state: Bool) {
        settings.hapticFeedback = state
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
