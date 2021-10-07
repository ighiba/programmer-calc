//
//  HelpersMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

final class CalcMath {
    
    // CalcState storage
    private var calcStateStorage = CalcStateStorage()
    
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
        
        // Check for overflow
        // calculate max/min decSigned/Unsigned values with current wordSize value
        let max = Decimal().decPow(2, Decimal(wordSize_Global)) - 1
        let maxSigned = Decimal().decPow(2, Decimal(wordSize_Global-1)) - 1
        let minSigned = Decimal().decPow(2, Decimal(wordSize_Global-1)) * -1
        
        let processSigned = calcStateStorage.isProcessSigned()
        // check for overflow
        if abs(newDecimal.decimalValue) > maxSigned {
            var decResult = newDecimal.decimalValue
            // process overflow for different ways
            if processSigned && newDecimal.decimalValue > maxSigned {
                // count how much is overflowed after calculation
                var decCount = newDecimal.decimalValue / (maxSigned + Decimal(1))
                var decCountCopy = decCount
                // round decCount
                NSDecimalRound(&decCount, &decCountCopy, 0, .down)
                decResult = newDecimal.decimalValue+(minSigned*2) * decCount
                
            } else if processSigned && newDecimal.decimalValue < minSigned {
                
                var decCount = newDecimal.decimalValue / (minSigned + Decimal(1))
                var decCountCopy = decCount
                NSDecimalRound(&decCount, &decCountCopy, 0, .down)
                decResult = newDecimal.decimalValue-(minSigned*2) * decCount
                
            } else if !processSigned && newDecimal.decimalValue > max {
                
                var decCount = newDecimal.decimalValue / (max + Decimal(1))
                var decCountCopy = decCount
                NSDecimalRound(&decCount, &decCountCopy, 0, .down)
                decResult = newDecimal.decimalValue-max * decCount
            }
            // update decimal
            newDecimal.setNewDecimal(with: decResult)
        }
        
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
            if let dec = shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: .shiftLeft, shiftCount: Int(secondNum.value)!) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
            }
            
        // Bitwise shift right
        case .shiftRight:
            guard !firstNum.value.contains(".") && !secondNum.value.contains(".") else {
                return secondNum
            }
            // TODO: Error handling
            if let dec = shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: .shiftRight, shiftCount: Int(secondNum.value)!) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
            }
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
            if let binary = Binary(buffResult) {
                // delete zeros before for binary
                binary.value = binary.removeZerosBefore(str: binary.value)
                
                // not result (invert binary)
                binary.invert()
                // convert to decimal and return
                return DecimalSystem(binary)
            } else {
                return nil
            }
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
        // fill up bits (0) to current word size
        resultStr = fillUpZeros(str: resultStr, to: wordSize_Global)
        
        return resultStr
    }
    
    public func negate(value: NumberSystemProtocol, system: ConversionSystemsEnum) -> NumberSystemProtocol {
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let convertedDecimal: DecimalSystem
        convertedDecimal = converterHandler.convertValue(value: value, from: system, to: .dec)! as! DecimalSystem
        
        // if 0 then return input value
        guard convertedDecimal.decimalValue != 0 else {
            return value
        }
        // multiple by -1
        let newDecimalValue = -1 * convertedDecimal.decimalValue
        
        // ======================
        // Convert Decimal to Any
        // ======================
        let newDecimal = DecimalSystem(newDecimalValue)

        if system != .dec {
            // TODO: Error handling
            let negatedValue = converterHandler.convertValue(value: newDecimal, from: .dec, to: system)!
            return negatedValue
        } else {
            return newDecimal
        }
    }
    
    // Shift to needed bit count
    public func shiftBits( value: NumberSystemProtocol, mainSystem: ConversionSystemsEnum, shiftOperation: CalcMath.mathOperation, shiftCount: Int ) -> NumberSystemProtocol? {
        // check if shift out of max bit index QWORD - 64
        // shifting more than 64 make no sense
        guard abs(shiftCount) < 64 else {
            // return 0
            return converterHandler.convertValue(value: Binary(stringLiteral: "0"), from: .bin, to: mainSystem)
        }
        
        // convert to Binary
        let binary = converterHandler.convertValue(value: value, from: mainSystem, to: .bin) as? Binary
        
        // check if binary is nil
        guard binary != nil else { return nil }
        
        // get operation
        let operation: CalcMath.mathOperation = {
            if shiftCount < 0 {
                // swap operation if shift count < 0
                if shiftOperation == .shiftRight {
                    return .shiftLeft
                } else {
                    return .shiftRight
                }
            } else {
                // keep inpu value if shift count > 0
                return shiftOperation
            }
        }()
    
        // chosing shifting method for signed or unsigned value
        if calcStateStorage.isProcessSigned() {
            // For signed
            let decStr = "\(binary!.convertBinaryToDec())"
            var newInt = 0
            if operation == .shiftLeft {
                newInt = Int(decStr)!<<abs(shiftCount)
            } else if operation == .shiftRight {
                newInt = Int(decStr)!>>abs(shiftCount)
            } else {
                // if wrong operation
                newInt = 0
            }
            if let bin = DecimalSystem(newInt).convertDecToBinary() {
                binary!.value = bin.value
            } else {
                return nil
            }
            //binary!.value = DecimalSystem(newInt).convertDecToBinary().value
        } else {
            // For unsigned
            // loop shiftCount for x>>y and x<<y
            for i in 0..<abs(shiftCount) {
                print(abs(i))
                if operation == .shiftLeft {
                    // <<
                    // append from right
                    binary!.value.append("0")
                } else if operation == .shiftRight {
                    // >>
                    // remove from right
                    if binary!.value.count > 0 {
                        binary!.value.removeLast(1)
                    } else {
                        binary!.value = "0"
                    }
                } else {
                    // if wrong operation
                    binary!.value = "0"
                }
            }
        }
        
        // TODO: Remove?
        // delete first bit if more than QWORD
        if binary!.value.removeAllSpaces().count > 64 {
            binary!.value.removeFirst(1)
        }
        
        return converterHandler.convertValue(value: Binary(stringLiteral: binary!.value), from: .bin, to: mainSystem)
    }
}
