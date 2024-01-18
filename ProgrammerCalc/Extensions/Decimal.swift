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

    var intPart: UInt64 { NSDecimalNumber(decimal: self.rounded(.down)).uint64Value }
    var floatPart: Decimal { abs(self) - abs(self).rounded(.down) }
    
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
            let roundingDifference = dec - decRounded
            result = roundingDifference * rhs
        } else {
            result = 0
        }

        return result
    }
}
