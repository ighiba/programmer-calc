//
//  BinaryOperator.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

enum BinaryOperator: String {
    case add = "+"
    case sub = "-"
    case mul = "×"
    case div = "÷"
    case and = "AND"
    case or = "OR"
    case xor = "XOR"
    case nor = "NOR"
    case shiftLeftBy = "X<<Y"
    case shiftRightBy = "X>>Y"
    
    var isBitwise: Bool {
        switch self {
        case .add, .sub, .mul, .div:
            return false
        default:
            return true
        }
    }
}
