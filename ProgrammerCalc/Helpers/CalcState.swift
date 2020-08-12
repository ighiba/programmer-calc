//
//  CalcState.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation
// ================
// For UserDefaults
// ================

class CalcState: Codable {
    var mainLabelState: String
    var converterLabelState: String
    
    init(mainState:String, convertState: String) {
        self.mainLabelState = mainState
        self.converterLabelState = convertState
    }
    
}
