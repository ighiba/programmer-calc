//
//  Decimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

extension Decimal {
    
    var intPart: UInt64 {
        let roundingBehavior = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: 0,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        return NSDecimalNumber(decimal: self).rounding(accordingToBehavior: roundingBehavior).uint64Value
    }
    
    var fractPartDigitCount: Int { fractPart.count }
    var fractPart: String {
        let components = self.description.components(separatedBy: ".")
        if components.count > 1 {
            return components[1]
        }
        return ""
    }
    
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
    
    func round(scale: Int16, roundingModeMode: NSDecimalNumber.RoundingMode) -> Decimal {
        let roundingBehavior = NSDecimalNumberHandler(
            roundingMode: roundingModeMode,
            scale: scale,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        return NSDecimalNumber(decimal: self).rounding(accordingToBehavior: roundingBehavior).decimalValue
    }
    
    static func % (lhs: Decimal, rhs: Decimal) -> Decimal {
        let result: Decimal

        let dec = lhs / rhs
        let decRounded = dec.round(scale: 0, roundingModeMode: .down)
        
        if dec > decRounded {
            let roundDifference = dec - decRounded
            result = roundDifference * rhs
        } else {
            result = 0
        }

        return result
    }
}
