//
//  ConversionStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 01.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol ConversionStorageProtocol {
    func loadData() -> ConversionSettingsProtocol?
    func saveData(_ conversion: ConversionSettingsProtocol)
}

class ConversionStorage: ConversionStorageProtocol {
    // ==================
    // MARK: - Properties
    // ==================
    
    // storage key
    private var key = "conversionSettings"
    
    // link to storage
    private var storage = UserDefaults.standard
    
    func loadData() -> ConversionSettingsProtocol? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            // if data doesn't exists
            return nil
        }
        // if data (stored value) exists
        return try? JSONDecoder().decode(ConversionSettings.self, from: data)
    }
    
    func saveData(_ conversion: ConversionSettingsProtocol) {
        if let data = try? JSONEncoder().encode(conversion as? ConversionSettings) {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            // delete data if doesn't encode
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}
