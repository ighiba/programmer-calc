//
//  CalcStateStorage.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 01.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol CalcStateStorageProtocol {
    func loadData() -> CalcStateProtocol?
    func saveData(_ state: CalcStateProtocol)
    func safeGetData() -> CalcStateProtocol
}

class CalcStateStorage: CalcStateStorageProtocol {

    // MARK: - Properties

    // storage key
    private var key = "calcState"
    
    // link to storage
    private var storage = UserDefaults.standard
    
    func loadData() -> CalcStateProtocol? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            // if data doesn't exists
            return nil
        }
        // if data (stored value) exists
        return try? JSONDecoder().decode(CalcState.self, from: data)
    }
    
    func saveData(_ state: CalcStateProtocol) {
        if let data = try? JSONEncoder().encode(state as? CalcState) {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            // delete data if doesn't encode
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    func isProcessSigned() -> Bool {
        return safeGetData().processSigned
    }

    func safeGetData() -> CalcStateProtocol {
        if let state = self.loadData() {
            return state
        }  else {
            // if no CalcState
            print("no CalcState")
            // default values
            let newState = CalcState(lastValue: PCDecimal(0), lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
            self.saveData(newState)
            
            return newState
        }
    }
}
