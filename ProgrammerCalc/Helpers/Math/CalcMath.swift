//
//  HelpersMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

final class CalcMath {
    
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
    
    // =======
    // Methods
    // =======
    
    func calculate( firstValue: String, operation: mathOperation ,secondValue: String, for system: String) -> String? {
        var resultStr: String?
        
        // Convert sytem string to enum
        let enumSystem: ConversionModel.ConversionSystemsEnum = {
            switch system {
            case "Binary":
                return .bin
            case "Decimal":
                return .dec
            case "Octal":
                return .oct
            case "Hexadecimal":
                return .hex
            default:
                // TODO: Error handling
                return .dec
            }
            
        }()
        
        // Pick system
        switch enumSystem {
        case .bin:
            resultStr = calculateBinNumbers(firstNum: firstValue, secondNum: secondValue, operation: operation)
            break
        case .dec:
            resultStr = calculateDecNumbers(firstNum: firstValue, secondNum: secondValue, operation: operation)
            break
        case .oct:
            break
        case .hex:
            break
        }
        
        return resultStr
    }
    
    // For equaling count of digits by adding zeros before and after the number
    func numberOfDigitsEqual( firstValue: String, secondValue: String) -> (String, String) {
        var resultStr = (String(), String())
        
        let firstDivided = MainConverter().divideToDoubleInt(str: firstValue)
        let secondDivided = MainConverter().divideToDoubleInt(str: secondValue)
        
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
}
