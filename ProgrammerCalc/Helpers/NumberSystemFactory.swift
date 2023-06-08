//
//  NumberSystemFactory.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 01.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

class NumberSystemFactory {
    
    func get(strValue value: String, currentSystem system: ConversionSystemsEnum) -> NumberSystemProtocol? {
        var buffValue: NumberSystemProtocol?
        
        switch system {
        case .bin:
            let dummyBin = Binary()
            dummyBin.value = value
            buffValue = Binary(dummyBin)
            break
        case .oct:
            buffValue = Octal(stringLiteral: value)
            break
        case .dec:
            buffValue = DecimalSystem(stringLiteral: value)
            break
        case .hex:
            buffValue = Hexadecimal(stringLiteral: value)
            break
        }
        
        return buffValue
    }
}

