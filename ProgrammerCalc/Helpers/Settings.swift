//
//  Settings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

final class Settings {
    
    // keys enumeration of settigs that stored in UserDefaults
    private enum Keys: String {
        case appSettings = "appSettings"
        case conversionSettings = "conversionSettings"
    }
    
    // For storing app setings
    static var appSettings: SettingsModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.appSettings.rawValue) else {
                // if data doesn't exists
                return nil
            }
            // if data (stored value) exists
            return try? JSONDecoder().decode(SettingsModel.self, from: data)
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: Keys.appSettings.rawValue)
            } else {
                // delete data if doesn't encode
                UserDefaults.standard.removeObject(forKey: Keys.appSettings.rawValue)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    // For storing conversion settings
    static var conversionSettings: ConversionSettingsModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.conversionSettings.rawValue) else {
                // if data doesn't exists
                return nil
            }
            // if data (stored value) exists
            return try? JSONDecoder().decode(ConversionSettingsModel.self, from: data)
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: Keys.conversionSettings.rawValue)
            } else {
                // delete data if doesn't encode
                UserDefaults.standard.removeObject(forKey: Keys.conversionSettings.rawValue)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
}
