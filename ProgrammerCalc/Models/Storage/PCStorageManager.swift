//
//  PCStorageManager.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import Foundation

protocol StorageManager {
    func loadAll()
    func saveAll()
}

final class PCStorageManager: StorageManager {
    
    private let wordSize: WordSize = .shared
    private let calculatorState: CalculatorState = .shared
    private let conversionSettings: ConversionSettings = .shared
    private let settings: Settings = .shared
    private let styleSettings: StyleSettings = .shared
    
    private let storage = CalculatorStorage()
    
    // Call this before CalculatorModuleAssembly.configureModule() in SceneDelegate willConnectTo
    func loadAll() {
        let wordSizeData: WordSize = storage.loadData()
        let calculatorStateData: CalculatorState = storage.loadData()
        let conversionSettingsData: ConversionSettings = storage.loadData()
        let settingsData: Settings = storage.loadData()
        let styleSettingsData: StyleSettings = storage.loadData()
        
        wordSize.set(wordSizeData)
        calculatorState.set(calculatorStateData)
        conversionSettings.set(conversionSettingsData)
        settings.set(settingsData)
        styleSettings.set(styleSettingsData)
    }
    
    func saveAll() {
        storage.saveData(wordSize)
        storage.saveData(calculatorState)
        storage.saveData(conversionSettings)
        storage.saveData(settings)
        storage.saveData(styleSettings)
    }
}
