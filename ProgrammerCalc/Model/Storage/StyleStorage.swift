//
//  StyleStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol StyleStorageProtocol {
    func loadData() -> StyleType?
    func saveData(_ style: StyleType)
    func safeGetStyleData() -> StyleType
    func loadState() -> Bool?
    func saveState(_ state: Bool)
    func safeGetSystemStyle() -> Bool
}

class StyleStorage: StyleStorageProtocol {
    // MARK: - Properties

    // storage keys
    private var keyStyle = "style"
    private var keyStyleState = "styleState"
    
    // link to storage
    private var storage = UserDefaults.standard
    
    // Load / Save style
    func loadData() -> StyleType? {
        guard let data = storage.object(forKey: keyStyle) as? String else {
            // if data doesn't exists
            return nil
        }
        // if data (stored value) exists
        return StyleType(rawValue: data)
    }
    
    func saveData(_ style: StyleType) {
        let data = style.rawValue
        storage.set(data, forKey: keyStyle)
        storage.synchronize()
    }
    
    // Load / Save state
    func loadState() -> Bool? {
        guard let data = storage.object(forKey: keyStyleState) as? Bool else {
            // if data doesn't exists
            return nil
        }
        // if data (stored value) exists
        return data
    }
    
    func saveState(_ state: Bool) {
        storage.set(state, forKey: keyStyleState)
        storage.synchronize()
    }


    func safeGetStyleData() -> StyleType {
        if let style = self.loadData() {
            return style
        }  else {
            // if no Style
            print("no Style")
            // default values
            let defaultStyle: StyleType = .dark
            self.saveData(defaultStyle)
            
            return defaultStyle
        }
    }
    
    func safeGetSystemStyle() -> Bool {
        if let state = self.loadState() {
            return state
        }  else {
            // if no state
            print("no Style")
            // default values
            self.saveState(false)
            
            return false
        }
    }
}
