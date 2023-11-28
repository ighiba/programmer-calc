//
//  Decimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

extension Decimal {
    
    typealias RoundingMode = NSDecimalNumber.RoundingMode

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
    
    func rounded(_ roundingMode: RoundingMode) -> Decimal {
        return rounded(scale: 0, roundingMode: roundingMode)
    }

    func rounded(scale: Int16, roundingMode: RoundingMode) -> Decimal {
        let roundingBehavior = NSDecimalNumberHandler(
            roundingMode: roundingMode,
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
        let decRounded = dec.rounded(.down)
        
        if dec > decRounded {
            let roundDifference = dec - decRounded
            result = roundDifference * rhs
        } else {
            result = 0
        }

        return result
    }
}
