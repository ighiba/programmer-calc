//
//  OperatorType.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

class OperatorFactory {
    func get(byStringValue stringValue: String) -> OperatorType {
        return OperatorType(rawValue: stringValue) ?? .none
    }
}

enum OperatorType: String {
    case add = "+"
    case sub = "-"
    case mul = "×"
    case div = "÷"

    case oneS = "1's"
    case twoS = "2's"
    case shiftLeft = "<<"
    case shiftRight = ">>"
    case shiftLeftBy = "X<<Y"
    case shiftRightBy = "X>>Y"

    case and = "AND"
    case or = "OR"
    case xor = "XOR"
    case nor = "NOR"
    
    case none = ""
    
    var isUnaryOperator: Bool {
        switch self {
        case .oneS, .twoS, .shiftLeft, .shiftRight:
            return true
        default:
            return false
        }
    }
}
