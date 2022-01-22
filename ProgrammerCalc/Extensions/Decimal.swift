//
//  Decimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

extension Decimal {
    // Converting binary string in decimal number
    init(_ str: String, radix: Int) {
        self.init()
        var decimal = Decimal()
        var multiplier = str.count - 1
        for bit in str {
            let bitDecimal: Decimal = bit == "1" ? 1 : 0
            let powDecimal = pow(Decimal(radix), multiplier)
            decimal += bitDecimal * powDecimal
            multiplier -= 1
        }
        self = decimal
    }
    
    // % for decimal values
    static func % (left: Decimal, right: Decimal) -> Decimal {
        var reminder = Decimal()
        
        var dec = left / right
        var decCopy = dec
        NSDecimalRound(&dec, &decCopy, 0, .down)
        if decCopy > dec {
            let buffDec = decCopy - dec
            reminder = buffDec * right
            
        } else {
            reminder = Decimal(0)
        }
        
        return reminder
    }
}
