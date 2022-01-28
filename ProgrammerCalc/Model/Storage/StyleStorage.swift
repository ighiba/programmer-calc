//
//  StyleStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol StyleStorageProtocol {
    func loadData() -> StyleSettingsProtocol?
    func saveData(_ styleSettings: StyleSettingsProtocol)
    func safeGetData() -> StyleSettingsProtocol
}

class StyleStorage: StyleStorageProtocol {
    // MARK: - Properties

    // storage key
    private var key = "styleSettings"
    
    // link to storage
    private var storage = UserDefaults.standard
    
    // Load / Save style settings
    func loadData() -> StyleSettingsProtocol? {
        guard let data = storage.data(forKey: key) else {
            // if data doesn't exists
            return nil
        }
        // if data (stored value) exists
        return try? JSONDecoder().decode(StyleSettings.self, from: data)
    }
    
    func saveData(_ styleSettings: StyleSettingsProtocol) {
        if let data = try? JSONEncoder().encode(styleSettings as? StyleSettings) {
            storage.set(data, forKey: key)
        } else {
            // delete data if doesn't encode
            storage.removeObject(forKey: key)
        }
        storage.synchronize()
    }

    func safeGetData() -> StyleSettingsProtocol {
        if let styleSettings = self.loadData() {
            return styleSettings
        }  else {
            print("no Style Settings")
            // default values
            let defaultStyleSettings: StyleSettings = StyleSettings(isUsingSystemAppearance: false, currentStyle: .dark)
            self.saveData(defaultStyleSettings)
            
            return defaultStyleSettings
        }
    }
}
