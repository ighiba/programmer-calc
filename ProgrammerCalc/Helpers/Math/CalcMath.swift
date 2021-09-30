//
//  HelpersMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

final class CalcMath {
    
    // Handlers
    let converterHandler: ConverterHandler = ConverterHandler()
    
    enum mathOperation {
        case add
        case sub
        case mul
        case div
        // bitwise
        case shiftLeft //  X << Y
        case shiftRight // X >> Y
        case and
        case or
        case xor
        case nor
    }
    
    struct MathState {
        
        var buffValue: String
        var operation: mathOperation
        var lastResult: String?
        var inputStart: Bool = false
        
        init(buffValue:String, operation: mathOperation) {
            self.buffValue = buffValue
            self.operation = operation
        }
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    func calculate( firstValue: String, operation: mathOperation ,secondValue: String, for system: String) -> String? {
  
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let firstConvertedStr: String
        let secondConvertedStr: String
        
        if system != "Decimal" {
            firstConvertedStr = converterHandler.convertValue(value: firstValue, from: system, to: "Decimal")!
            secondConvertedStr = converterHandler.convertValue(value: secondValue, from: system, to: "Decimal")!
        } else {
            firstConvertedStr = firstValue
            secondConvertedStr = secondValue
        }
        
        // ========================
        // Calculate Decimal values
        // ========================
        let decimalStr = calculateDecNumbers(firstNum: firstConvertedStr, secondNum: secondConvertedStr, operation: operation)
        
        // ======================
        // Convert Decimal to Any
        // ======================
        
        if system != "Decimal" {
            return converterHandler.convertValue(value: decimalStr!, from: "Decimal", to: system)
        } else {
            return decimalStr
        }
   
    }
    
    // Calculation of 2 decimal numbers by .operation
    // TODO: Make error handling for overflow
    fileprivate func calculateDecNumbers( firstNum: String, secondNum: String, operation: CalcMath.mathOperation) -> String? {
        var resultStr: String = String()

        let firstDecimal = Decimal(string: firstNum)
        let secondDecimal = Decimal(string: secondNum)

        switch operation {
        // Addition
        case .add:
            resultStr = "\(firstDecimal! + secondDecimal!)"
        // Subtraction
        case .sub:
            resultStr = "\(firstDecimal! - secondDecimal!)"
        // Multiplication
        case .mul:
            resultStr = "\(firstDecimal! * secondDecimal!)"
        // Division
        case .div:
            // if dvision by zero
            guard secondDecimal != 0 else {
                // TODO Make error code and replace hardcode
                return "Division by zero"
            }
            resultStr = "\(firstDecimal! / secondDecimal!)"
        // Bitwise shift left
        case .shiftLeft:
            // TODO: Refactor
            guard !firstNum.contains(".") && !secondNum.contains(".") else {
                return secondNum
            }
            // TODO: Error handling
            resultStr = converterHandler.shiftBits(value: firstNum, mainSystem: "Decimal", shiftOperation: <<, shiftCount: Int(secondNum)!)
        // Bitwise shift right
        case .shiftRight:
            guard !firstNum.contains(".") && !secondNum.contains(".") else {
                return secondNum
            }
            // TODO: Error handling
            resultStr = converterHandler.shiftBits(value: firstNum, mainSystem: "Decimal", shiftOperation: >>, shiftCount: Int(secondNum)!)
        // bitwise and
        case .and:
            guard !firstNum.contains(".") && !secondNum.contains(".") else {
                return secondNum
            }
            // x and y
            resultStr = "\(Int(firstNum)! & Int(secondNum)!)"
        // bitwise or
        case .or:
            guard !firstNum.contains(".") && !secondNum.contains(".") else {
                return secondNum
            }
            // x or y
            resultStr = "\(Int(firstNum)! | Int(secondNum)!)"
        // bitwise xor
        case .xor:
            guard !firstNum.contains(".") && !secondNum.contains(".") else {
                return secondNum
            }
            // x xor y
            resultStr = "\(Int(firstNum)! ^ Int(secondNum)!)"
        // bitwise nor
        case .nor:
            guard !firstNum.contains(".") && !secondNum.contains(".") else {
                return secondNum
            }
            // x or y
            let buffResult = DecimalSystem(Decimal(Int(firstNum)! | Int(secondNum)!))
            // convert to binary
            let binary = Binary(buffResult)
            // delete zeros before for binary
            binary.value = binary.removeZerosBefore(str: binary.value)
            
            // not result (invert binary)
            binary.invert()
            // convert to decimal
            let decimal = DecimalSystem(binary)
            
            resultStr = "\(decimal)"
        }
        return resultStr
    }
    
    func fillUpZeros( str: String, to num: Int) -> String {
        let diffInt = num - str.count
        
        return String(repeating: "0", count: diffInt) + str
    }
    
    // Filling binary number by 8, 16, 32, 64
    func fillUpBits( str: String) -> String {
        var resultStr = str
        // brute force powers of 2; from 8 to 64
        // number of bits in binary number
        for power in 3...6 {
            let bits = powf(2, Float(power))
            if resultStr.count < Int(bits) {
                resultStr = fillUpZeros(str: resultStr, to: Int(bits))
                return resultStr
            }
        }
        
        return resultStr
    }
    
    public func negate(valueStr: String, system: String) -> String {
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let valueConvertedStr: String
        
        if system != "Decimal" {
            // TOOD: Error handling
            valueConvertedStr = converterHandler.convertValue(value: valueStr, from: system, to: "Decimal")!
        } else {
            valueConvertedStr = valueStr
        }
        
        // Negate decimal number
        let decimal = Decimal(string: valueConvertedStr)!
        // if 0 then return input value
        guard decimal != 0 else {
            return valueStr
        }
        // multiple by -1
        let decimalStr = "\(-1 * decimal)"
        
        // ======================
        // Convert Decimal to Any
        // ======================
        
        if system != "Decimal" {
            // TODO: Error handling
            return converterHandler.convertValue(value: decimalStr, from: "Decimal", to: system)!
        } else {
            return decimalStr
        }
    }
}
