//
//  PCalcStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import Foundation

class PCalcStorage {
    
    private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    private let settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private let conversionStorage: ConversionStorageProtocol = ConversionStorage()
    private let calcStateStorage: CalcStateStorageProtocol = CalcStateStorage()
    private let styleStorage: StyleStorageProtocol = StyleStorage()

    // Call this before PCalcViewController init in SceneDelegate willConnectTo
    public func loadAll() {
        let wordSize = wordSizeStorage.safeGetData()
        let settings = settingsStorage.safeGetData()
        let conversionSettings = conversionStorage.safeGetData()
        let calcState = calcStateStorage.safeGetData()
        let styleSettigns = styleStorage.safeGetData()
        // Set shared instatnces
        WordSize.shared.setWordSize(wordSize)
        Settings.shared.setSettings(settings)
        ConversionSettings.shared.setConversionSettings(conversionSettings)
        CalcState.shared.setCalcState(calcState)
        StyleSettings.shared.setStyleSettings(styleSettigns)
    }
    
    public func saveAll() {
        let wordSize = WordSize.shared
        let settings = Settings.shared
        let conversionSettings = ConversionSettings.shared
        let calcState = CalcState.shared
        let styleSettings = StyleSettings.shared
        // Save data
        wordSizeStorage.saveData(wordSize)
        settingsStorage.saveData(settings)
        conversionStorage.saveData(conversionSettings)
        calcStateStorage.saveData(calcState)
        styleStorage.saveData(styleSettings)
    }
}
