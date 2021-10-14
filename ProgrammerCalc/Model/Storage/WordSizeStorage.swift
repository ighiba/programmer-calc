//
//  WordSizeStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol WordSizeStorageProtocol {
    func loadData() -> WordSizeProtocol?
    func saveData(_ size: WordSizeProtocol)
    func safeGetData() -> WordSizeProtocol
    func getWordSizeValue() -> Int
}

class WordSizeStorage: WordSizeStorageProtocol {
    // ==================
    // MARK: - Properties
    // ==================
    
    // storage key
    private var key = "wordSize"
    
    // link to storage
    private var storage = UserDefaults.standard
    
    func loadData() -> WordSizeProtocol? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            // if data doesn't exists
            return nil
        }
        // if data (stored value) exists
        return try? JSONDecoder().decode(WordSize.self, from: data)
    }
    
    func saveData(_ size: WordSizeProtocol) {
        if let data = try? JSONEncoder().encode(size as? WordSize) {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            // delete data if doesn't encode
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    // get data from UserDefaults
    // if no data then write default value
    // and return it
    func safeGetData() -> WordSizeProtocol {
        if let size = self.loadData() {
            return size
        }  else {
            // if no WordSize
            print("no WordSize")
            // default values
            let newSize = WordSize(64)
            self.saveData(newSize)
            
            return newSize
        }
    }
    
    func getWordSizeValue() -> Int {
        return safeGetData().value
    }

    
}

