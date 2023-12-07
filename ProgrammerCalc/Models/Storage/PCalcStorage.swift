//
//  PCalcStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import Foundation

class PCalcStorage {
    
    private let storage = CalculatorStorage()
    
    // Call this before CalculatorModuleAssembly.configureModule() in SceneDelegate willConnectTo
    public func loadAll() {
        let wordSize: WordSize = storage.loadData()
        let settings: Settings = storage.loadData()
        let conversionSettings: ConversionSettings = storage.loadData()
        let calcState: CalculatorState = storage.loadData()
        let styleSettigns: StyleSettings = storage.loadData()

        WordSize.shared.setWordSize(wordSize)
        Settings.shared.setSettings(settings)
        ConversionSettings.shared.setConversionSettings(conversionSettings)
        CalculatorState.shared.setCalcState(calcState)
        StyleSettings.shared.setStyleSettings(styleSettigns)
    }
    
    public func saveAll() {
        let wordSize = WordSize.shared
        let settings = Settings.shared
        let conversionSettings = ConversionSettings.shared
        let calcState = CalculatorState.shared
        let styleSettings = StyleSettings.shared

        storage.saveData(wordSize)
        storage.saveData(settings)
        storage.saveData(conversionSettings)
        storage.saveData(calcState)
        storage.saveData(styleSettings)
    }
}
