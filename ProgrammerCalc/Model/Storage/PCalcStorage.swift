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

    // Call this before PCalcViewController init in SceneDelegate willConnectTo
    public func loadAll() {
        let wordSize = wordSizeStorage.safeGetData()
        let settings = settingsStorage.safeGetData()
        let conversionSettings = conversionStorage.safeGetData()
        let calcState = calcStateStorage.safeGetData()
        // Set shared instatnces
        WordSize.shared.setWordSize(wordSize)
        Settings.shared.setSettings(settings)
        ConversionSettings.shared.setConversionSettings(conversionSettings)
        CalcState.shared.setCalcState(calcState)
    }
}
