//
//  NumberSystemFactory.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 01.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

class NumberSystemFactory {
    
    func get(strValue value: String, forSystem system: ConversionSystem) -> NumberSystemProtocol {
        let result: NumberSystemProtocol
        
        switch system {
        case .bin:
            result = Binary(rawStringLiteral: value)
        case .oct:
            result = Octal(stringLiteral: value)
        case .dec:
            result = DecimalSystem(stringLiteral: value)
        case .hex:
            result = Hexadecimal(stringLiteral: value)
        }
        
        return result
    }
}
