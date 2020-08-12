//
//  BinaryMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

extension CalcMath {
    
    // ======
    // Binary
    // ======
    
    // Calculation of 2 binary numbers by .operation
    // TODO: Make error handling for overflow
    func calculateBinNumbers( firstNum: String, secondNum: String, operation: CalcMath.mathOperation) -> String? {
        var resultStr: String = String()

        switch operation {
        // Addition
        case .add:
            resultStr = addBinary(firstNum, secondNum)
            break
        // Subtraction
        case .sub:
            break
        // Multiplication
        case .mul:
            break
        // Division
        case .div:
            // if dvision by zero
            guard Int(secondNum) != 0 else {
                // TODO Make error code and replace hardcode
                return "Division by zero"
            }
            break
        }
        return resultStr
    }
    
    // Addition of binary numbers
    public func addBinary(_ firstValue: String, _ secondValue: String) -> String {
        var resultStr = String()
        
        // TODO: Check for binary

        // Make values equal (by lenght)
        let equaled = numberOfDigitsEqual(firstValue: firstValue, secondValue: secondValue)
        
        var firstBinary = equaled.0
        var secondBinary = equaled.1
        
        var reminder = 0
        
        // Do addition
        while firstBinary != "" {
            let firstLast = String(firstBinary.last!)
            let secondLast = String(secondBinary.last!)
            
            // if point then new iteration
            guard firstLast != "." && secondLast != "." else {
                resultStr = "." + resultStr
                firstBinary.removeLast()
                secondBinary.removeLast()
                continue
            }
            // calculate ints
            let intBuff = Int(firstLast)! + Int(secondLast)! + reminder
            // process calculation result
            switch intBuff {
            case 0:
                resultStr = "0" + resultStr
                break
            case 1:
                resultStr = "1" + resultStr
                reminder = 0
                break
            case 2:
                resultStr = "0" + resultStr
                reminder = 1
                break
            case 3:
                resultStr = "1" + resultStr
                reminder = 1
            default:
                break
            }
            
            firstBinary.removeLast()
            secondBinary.removeLast()
        }
        
        // add last reminder if not 0
        if reminder == 1 {
            resultStr = "1" + resultStr
        }

        return resultStr
    }
    
    // inverting value 1 -> 0; 0 -> 1
    static func invertBinary(binary: String) -> String {
        var resultStr = String()
        
        binary.forEach { (num) in
            switch num {
            case "0":
                resultStr.append("1")
            case "1":
                resultStr.append("0")
            default:
                resultStr.append(num)
                break
            }
        }
        return resultStr
    }
    
}
