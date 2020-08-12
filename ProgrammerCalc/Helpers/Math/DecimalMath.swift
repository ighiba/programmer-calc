//
//  DecimalMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

extension CalcMath {
    // =======
    // Decimal
    // =======
    
    // Calculation of 2 decimal numbers by .operation
    // TODO: Make error handling for overflow
    static func calculateDecNumbers( firstNum: String, secondNum: String, operation: CalcMath.mathOperation) -> String? {
        var resultStr: String = String()

        let firstDecimal = Decimal(string: firstNum)
        let secondDecimal = Decimal(string: secondNum)

        switch operation {
        // Addition
        case .add:
            resultStr = "\(firstDecimal! + secondDecimal!)"
            break
        // Subtraction
        case .sub:
            resultStr = "\(firstDecimal! - secondDecimal!)"
            break
        // Multiplication
        case .mul:
            resultStr = "\(firstDecimal! * secondDecimal!)"
            break
        // Division
        case .div:
            // if dvision by zero
            guard secondDecimal != 0 else {
                // TODO Make error code and replace hardcode
                return "Division by zero"
            }
            resultStr = "\(firstDecimal! / secondDecimal!)"
            break

        }

        return resultStr

        }
}
