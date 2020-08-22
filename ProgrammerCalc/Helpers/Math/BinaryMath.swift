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
        var resultBin = Binary()
        
        let firstBin = Binary()
        let secondBin = Binary()

        firstBin.value = firstBin.removeAllSpaces(str: firstNum)
        secondBin.value = secondBin.removeAllSpaces(str: secondNum)
        
        switch operation {
        // Addition
        case .add:
            resultBin = addBinary(firstBin, secondBin)
            break
        // Subtraction
        case .sub:
            resultBin = subBinary(firstBin, secondBin)
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
        return resultBin.value
    }
    
    // Addition of binary numbers
    public func addBinary(_ firstValue: Binary, _ secondValue: Binary) -> Binary {
        let resultBin = Binary()
        
        // TODO: Check for binary

        // Make values equal (by lenght)
        let equaled = numberOfDigitsEqual(firstValue: firstValue.value, secondValue: secondValue.value)
        
        var firstBinary = equaled.0
        var secondBinary = equaled.1
        
        var reminder = 0
        
        // Do addition
        while firstBinary != "" {
            let firstLast = String(firstBinary.last!)
            let secondLast = String(secondBinary.last!)
            
            // if point then new iteration
            guard firstLast != "." && secondLast != "." else {
                resultBin.value = "." + resultBin.value
                firstBinary.removeLast()
                secondBinary.removeLast()
                continue
            }
            // calculate ints
            let intBuff = Int(firstLast)! + Int(secondLast)! + reminder
            // process calculation result
            switch intBuff {
            case 0:
                resultBin.value = "0" + resultBin.value
                break
            case 1:
                resultBin.value = "1" + resultBin.value
                reminder = 0
                break
            case 2:
                resultBin.value = "0" + resultBin.value
                reminder = 1
                break
            case 3:
                resultBin.value = "1" + resultBin.value
                reminder = 1
            default:
                break
            }
            
            firstBinary.removeLast()
            secondBinary.removeLast()
        }
        
        // add last reminder if not 0
        if reminder == 1 {
            resultBin.value = "1" + resultBin.value
        }

        return resultBin
    }
    
    // Subtraction of binary numbers
    public func subBinary(_ firstValue: Binary, _ secondValue: Binary) -> Binary {
        var resultBin = Binary()
        
        // TODO: Check for binary
        
        // Filling up values to needed bits
        //firstValue.value = fillUpBits(str: firstValue.value)
        //secondValue.value = fillUpBits(str: secondValue.value)
        // Inverting second value
        secondValue.value = invertBinary(binary: secondValue.value)
        
        // Subtracting secondValue from firstValue
        // Add first value + inverterd second value
        resultBin = addBinary(firstValue, secondValue)
        // Add + 1 for additional code
        resultBin = addBinary(resultBin, "1")
        // Delete left bit
        if resultBin.value.count % 2 != 0 {
            resultBin.value.removeFirst()
        }
        
        // TODO: Handle signed and unsigned numbers
        
        return resultBin
    }
    
    // inverting value 1 -> 0; 0 -> 1
    func invertBinary(binary: String) -> String {
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
