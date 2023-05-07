//
//  OperationFactory.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.05.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

class OperationFactory {
    
    func get(buttonLabel: String) -> CalcMath.OperationType {
        switch buttonLabel {
        case "÷":
            return .div
        case "×":
            return .mul
        case "-":
            return .sub
        case "+":
            return .add
        case "X<<Y":
            return .shiftLeftBy
        case "X>>Y":
            return .shiftRightBy
        case "<<":
            return .shiftLeft
        case ">>":
            return .shiftRight
        case "AND":
            return .and
        case "OR":
            return .or
        case "XOR":
            return .xor
        case "NOR":
            return .nor
        default:
            return .none
        }
    }
}
