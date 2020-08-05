//
//  ConversionModel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class ConversionModel {
    enum ConversionSystems: String {
        case bin = "Binary"
        case dec = "Decimal"
        case oct = "Octal"
        case hex = "Hexadecimal"
    }
    
    var selectedSystem: ConversionSystems
    var systemDescription: String
    
    init( system: ConversionSystems) {
        self.selectedSystem = system
        self.systemDescription = system.rawValue
    }
}
