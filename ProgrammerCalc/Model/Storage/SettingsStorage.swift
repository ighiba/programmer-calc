//
//  SettingsStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 01.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol SettingsStorageProtocol {
    func loadData() -> SettingsProtocol?
    func saveData(_ settings: SettingsProtocol)
    func safeGetData() -> SettingsProtocol
}

class SettingsStorage: SettingsStorageProtocol {
    // ==================
    // MARK: - Properties
    // ==================
    
    // storage key
    private var key = "appSettings"
    
    // link to storage
    private var storage = UserDefaults.standard
    
    func loadData() -> SettingsProtocol? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            // if data doesn't exists
            return nil
        }
        // if data (stored value) exists
        return try? JSONDecoder().decode(Settings.self, from: data)
    }
    
    func saveData(_ settings: SettingsProtocol) {
        if let data = try? JSONEncoder().encode(settings as? Settings) {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            // delete data if doesn't encode
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    func safeGetData() -> SettingsProtocol {
        if let settings = self.loadData() {
            return settings
        } else {
            // if no settings
            print("no App settings")
            // default values
            let newSettings = Settings(tappingSounds: true, hapticFeedback: true)
            self.saveData(newSettings)
            
            return newSettings
        }
    }
   
}
