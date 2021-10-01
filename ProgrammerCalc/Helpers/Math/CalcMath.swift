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
        
        var buffValue: NumberSystemProtocol
        var operation: mathOperation
        var lastResult: NumberSystemProtocol?
        var inputStart: Bool = false
        
        init(buffValue: NumberSystemProtocol, operation: mathOperation) {
            self.buffValue = buffValue
            self.operation = operation
        }
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    func calculate( firstValue: NumberSystemProtocol, operation: mathOperation ,secondValue: NumberSystemProtocol, for system: ConversionSystemsEnum) -> NumberSystemProtocol? {
  
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let firstConverted: DecimalSystem
        let secondConverted: DecimalSystem
        
        if system != .dec {
            firstConverted = converterHandler.convertValue(value: firstValue, from: system, to: .dec)! as! DecimalSystem
            secondConverted = converterHandler.convertValue(value: secondValue, from: system, to: .dec)! as! DecimalSystem
        } else {
            firstConverted = firstValue as! DecimalSystem
            secondConverted = secondValue as! DecimalSystem
        }
        
        // ========================
        // Calculate Decimal values
        // ========================
        let newDecimal = calculateDecNumbers(firstNum: firstConverted, secondNum: secondConverted, operation: operation)!
        
        // ======================
        // Convert Decimal to Any
        // ======================
        
        if system != .dec {
            return converterHandler.convertValue(value: newDecimal, from: .dec, to: system)
        } else {
            return newDecimal
        }
   
    }
    
    // Calculation of 2 decimal numbers by .operation
    // TODO: Make error handling for overflow
    fileprivate func calculateDecNumbers( firstNum: DecimalSystem, secondNum: DecimalSystem, operation: CalcMath.mathOperation) -> DecimalSystem? {
        var resultStr: String = String()

        let firstDecimal = firstNum.decimalValue
        let secondDecimal = secondNum.decimalValue

        switch operation {
        // Addition
        case .add:
            resultStr = "\(firstDecimal + secondDecimal)"
        // Subtraction
        case .sub:
            resultStr = "\(firstDecimal - secondDecimal)"
        // Multiplication
        case .mul:
            resultStr = "\(firstDecimal * secondDecimal)"
        // Division
        case .div:
            // if dvision by zero
            guard secondDecimal != 0 else {
                // TODO Make error code and replace hardcode
                let divByZero = DecimalSystem(0)
                divByZero.value = "Division by zero"
                return divByZero
            }
            resultStr = "\(firstDecimal / secondDecimal)"
        // Bitwise shift left
        case .shiftLeft:
            // TODO: Refactor
            guard !firstNum.value.contains(".") && !secondNum.value.contains(".") else {
                return secondNum
            }
            // TODO: Error handling
            let dec = converterHandler.shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: <<, shiftCount: Int(secondNum.value)!) as! DecimalSystem
            resultStr = dec.value
        // Bitwise shift right
        case .shiftRight:
            guard !firstNum.value.contains(".") && !secondNum.value.contains(".") else {
                return secondNum
            }
            // TODO: Error handling
            let dec = converterHandler.shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: >>, shiftCount: Int(secondNum.value)!) as! DecimalSystem
            resultStr = dec.value
        // bitwise and
        case .and:
            guard !firstNum.value.contains(".") && !secondNum.value.contains(".") else {
                return secondNum
            }
            // x and y
            resultStr = "\(Int(firstNum.value)! & Int(secondNum.value)!)"
        // bitwise or
        case .or:
            guard !firstNum.value.contains(".") && !secondNum.value.contains(".") else {
                return secondNum
            }
            // x or y
            resultStr = "\(Int(firstNum.value)! | Int(secondNum.value)!)"
        // bitwise xor
        case .xor:
            guard !firstNum.value.contains(".") && !secondNum.value.contains(".") else {
                return secondNum
            }
            // x xor y
            resultStr = "\(Int(firstNum.value)! ^ Int(secondNum.value)!)"
        // bitwise nor
        case .nor:
            guard !firstNum.value.contains(".") && !secondNum.value.contains(".") else {
                return secondNum
            }
            // x or y
            let buffResult = DecimalSystem(stringLiteral: "\(Int(firstNum.value)! | Int(secondNum.value)!)")
            // convert to binary
            let binary = Binary(buffResult)
            // delete zeros before for binary
            binary.value = binary.removeZerosBefore(str: binary.value)
            
            // not result (invert binary)
            binary.invert()
            // convert to decimal and return
            return DecimalSystem(binary)
        
        }
        
        // convert resultStr to DecimalSystem
        return DecimalSystem(stringLiteral: resultStr)
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
    
    public func negate(value: NumberSystemProtocol, system: ConversionSystemsEnum) -> NumberSystemProtocol {
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let convertedDecimal: DecimalSystem
        
        if system != .dec {
            // TOOD: Error handling
            convertedDecimal = converterHandler.convertValue(value: value, from: system, to: .dec)! as! DecimalSystem
        } else {
            convertedDecimal = value as! DecimalSystem
        }
        
        // Negate decimal number
        let decimalValue = convertedDecimal.decimalValue
        // if 0 then return input value
        guard decimalValue != 0 else {
            return value
        }
        // multiple by -1
        let newDecimalValue = -1 * decimalValue
        
        // ======================
        // Convert Decimal to Any
        // ======================
        let newDecimal = DecimalSystem(newDecimalValue)
        if system != .dec {
            // TODO: Error handling
            return converterHandler.convertValue(value: newDecimal, from: .dec, to: system)!
        } else {
            return newDecimal
        }
    }
}
