//
//  Character.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

extension Character {
    var isBinDigit: Bool { self == "0" || self == "1" }
    var isOctDigit: Bool { ConversionValues.getAllowed(for: .oct).contains(String(self)) }
    var isDecDigit: Bool { ConversionValues.getAllowed(for: .dec).contains(String(self)) }
    
    init(_ value: UInt8) {
        self.init(unicodeScalarLiteral: Character(String(value)))
    }
}
