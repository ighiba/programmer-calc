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
    
    // For equaling count of digits by adding zeros before and after the number
    func numberOfDigitsEqual( firstValue: String, secondValue: String) -> (String, String) {
        var resultStr = (String(), String())
        
        let firstDivided = NumberSystem().divideIntFract(value: firstValue)
        let secondDivided = NumberSystem().divideIntFract(value: secondValue)
        
        var firstInt = firstDivided.0!
        var secondInt = secondDivided.0!
        var firstFract = firstDivided.1
        var secondFract = secondDivided.1
        
        // Make equal int part
        if firstInt.count == secondInt.count {
            // if already equal
            // do nothing
        } else if firstInt.count > secondInt.count{
            // if first is bigger
            secondInt = fillUpZeros(str: secondInt, to: firstInt.count)
        } else {
            // if second is bigger
            firstInt = fillUpZeros(str: firstInt, to: secondInt.count)
        }
        // append int result
        resultStr.0.append(firstInt)
        resultStr.1.append(secondInt)
        
        // Check for fract part
        if firstFract == nil && secondFract == nil {
            // if no fract
            return resultStr
        }
        
        // append point to result
        resultStr.0.append(".")
        resultStr.1.append(".")
        
        // Make equal float part
        if firstFract == nil {
            firstFract = String(repeating: "0", count: secondFract!.count)
        } else if secondFract == nil{
            secondFract = String(repeating: "0", count: firstFract!.count)
        } else {
            // TODO: Refactor into 1 function
            if firstFract!.count == secondFract!.count {
                // if already equal
                // do nothing
            } else if firstFract!.count > secondFract!.count{
                // if first is bigger
                secondFract = String(secondFract!.reversed())
                secondFract = fillUpZeros(str: secondFract!, to: firstFract!.count)
                secondFract = String(secondFract!.reversed())
            } else {
                // if second is bigger
                firstFract = String(firstFract!.reversed())
                firstFract = fillUpZeros(str: firstFract!, to: secondFract!.count)
                firstFract = String(firstFract!.reversed())
            }
        }
        
        // append fract result
        resultStr.0.append(firstFract!)
        resultStr.1.append(secondFract!)
        
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
}
