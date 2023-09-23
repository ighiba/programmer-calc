//
//  CalculatorStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

class CalculatorStorage {
    private let storage = UserDefaults.standard
    
    func loadData<T: Storable>() -> T {
        guard let data = storage.data(forKey: T.storageKey) else {
            print("\(T.self) no saved data, return default data")
            return T.getDefault()
        }
        
        if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
            return decodedData
        } else {
            print("\(T.self) stored data cannot be decoded, return default data")
            return T.getDefault()
        }
    }

    func saveData<T: Storable>(_ data: T) {
        if let encodedData = try? JSONEncoder().encode(data) {
            storage.set(encodedData, forKey: T.storageKey)
        } else {
            storage.removeObject(forKey: T.storageKey)
        }
        storage.synchronize()
    }
}
