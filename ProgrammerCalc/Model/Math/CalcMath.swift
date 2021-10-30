//
//  HelpersMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

// Error
enum MathErrors: Error, CaseIterable {
    case divByZero
}

extension MathErrors: LocalizedError {

    public var localizedDescription: String? {
        switch self {
        case .divByZero:
            return NSLocalizedString("Cannot divide by zero", comment: "")
    }

 }
}

final class CalcMath {
        
    // Storages
    private let conversionStorage = ConversionStorage()
    private let calcStateStorage = CalcStateStorage()
    private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    
    // Object "Converter"
    let converter: Converter = Converter()
    
    enum MathOperation {
        case add
        case sub
        case mul
        case div
        // bitwise
        case shiftLeft //  <<
        case shiftRight //  >>
        case shiftLeftBy //  X << Y
        case shiftRightBy // X >> Y
        case and
        case or
        case xor
        case nor
    }
    
    struct MathState {
        
        var buffValue: NumberSystemProtocol
        var operation: MathOperation
        var lastResult: NumberSystemProtocol?
        var inputStart: Bool = false
        
        init(buffValue: NumberSystemProtocol, operation: MathOperation) {
            self.buffValue = buffValue
            self.operation = operation
        }
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    func calculate( firstValue: NumberSystemProtocol, operation: MathOperation ,secondValue: NumberSystemProtocol, for system: ConversionSystemsEnum) throws -> NumberSystemProtocol? {
  
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let firstConverted: DecimalSystem
        let secondConverted: DecimalSystem
        
        if system != .dec {
            firstConverted = converter.convertValue(value: firstValue, from: system, to: .dec)! as! DecimalSystem
            secondConverted = converter.convertValue(value: secondValue, from: system, to: .dec)! as! DecimalSystem
        } else {
            firstConverted = firstValue as! DecimalSystem
            secondConverted = secondValue as! DecimalSystem
        }
        
        // ========================
        // Calculate Decimal values
        // ========================
        var newDecimal: DecimalSystem?
        do {
            newDecimal = try calculateDecNumbers(firstNum: firstConverted, secondNum: secondConverted, operation: operation)!
        } catch MathErrors.divByZero {
            // Throw division by zero
            throw MathErrors.divByZero
        } catch {
            // else
        }
        
        // Format if overflow
        // get fract part if exists
        var decFractPart = newDecimal!.removeFractPart()
        var decFractPartCopy = decFractPart
        let numbersAfterPoint = Int(conversionStorage.safeGetData().numbersAfterPoint)
        NSDecimalRound(&decFractPart, &decFractPartCopy, numbersAfterPoint, .down)
        // convert to formatted bin
        let formattedBin = converter.convertValue(value: newDecimal!, from: .dec, to: .bin)
        // convert to decimal from bin
        let formattedDec = converter.convertValue(value: formattedBin!, from: .bin, to: .dec) as! DecimalSystem
        // add decimal fract part
        formattedDec.setNewDecimal(with: formattedDec.decimalValue + decFractPart)
        
        // Check if float and negative
        if formattedDec.value.contains(".") && formattedDec.decimalValue < 0 {
            // round decimal
            var dec = formattedDec.decimalValue
            var decCopy = dec
            NSDecimalRound(&dec, &decCopy, 0, .up)
            formattedDec.setNewDecimal(with: dec)
        }
        
        // ======================
        // Convert Decimal to Any
        // ======================
        
        if system != .dec {
            return converter.convertValue(value: formattedDec, from: .dec, to: system)
        } else {
            return formattedDec
        }
   
    }
    
    // Calculation of 2 decimal numbers by .operation
    fileprivate func calculateDecNumbers( firstNum: DecimalSystem, secondNum: DecimalSystem, operation: CalcMath.MathOperation) throws -> DecimalSystem? {
        var resultStr: String = String()

        let firstDecimal = firstNum.decimalValue
        let secondDecimal = secondNum.decimalValue

        switch operation {
        // Addition
        case .add:
            return DecimalSystem(firstDecimal + secondDecimal)
        // Subtraction
        case .sub:
            return DecimalSystem(firstDecimal - secondDecimal)
        // Multiplication
        case .mul:
            return DecimalSystem(firstDecimal * secondDecimal)
        // Division
        case .div:
            // if dvision by zero
            guard secondDecimal != 0 else {
                // Throw division by zero
                throw MathErrors.divByZero
            }
            return DecimalSystem(firstDecimal / secondDecimal)
        // Bitwise shift left
        case .shiftLeft:

            if let dec = shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: .shiftLeft, shiftCount: 1) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
            }
            
        // Bitwise shift right
        case .shiftRight:
            
            if let dec = shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: .shiftRight, shiftCount: 1) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
            }
            
        // bitwise and
        case .and:

            // x and y
            resultStr = calculateBitOperation(firstNum: firstNum, secondNum: secondNum, operation: { left, right in
                bitAnd(left: left, right: right)
            }).value
            
        // bitwise or
        case .or:

            // x or y
            resultStr = calculateBitOperation(firstNum: firstNum, secondNum: secondNum, operation: { left, right in
                bitOr(left: left, right: right)
            }).value

        // bitwise xor
        case .xor:

            // x xor y
            resultStr = calculateBitOperation(firstNum: firstNum, secondNum: secondNum, operation: { left, right in
                bitXor(left: left, right: right)
            }).value
            
        // bitwise nor
        case .nor:

            // x nor y
            resultStr = calculateBitOperation(firstNum: firstNum, secondNum: secondNum, operation: { left, right in
                let result = bitOr(left: left, right: right)
                // not result (invert binary)
                result.invert()
                return result
            }).value
        case .shiftLeftBy:
            if let dec = shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: .shiftLeft, shiftCount: Int(secondNum.value)!) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
            }
        case .shiftRightBy:
            if let dec = shiftBits(value: firstNum, mainSystem: .dec, shiftOperation: .shiftRight, shiftCount: Int(secondNum.value)!) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
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
        
        let wordSizeValue = wordSizeStorage.getWordSizeValue()
        
        // fill up bits (0) to current word size
        resultStr = fillUpZeros(str: resultStr, to: wordSizeValue)
        
        return resultStr
    }
    
    public func negate(value: NumberSystemProtocol, system: ConversionSystemsEnum) -> NumberSystemProtocol {
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let convertedDecimal: DecimalSystem
        convertedDecimal = converter.convertValue(value: value, from: system, to: .dec)! as! DecimalSystem
        
        // if 0 then return input value
        guard convertedDecimal.decimalValue != 0 else {
            return value
        }
        
        // Check if float
        if convertedDecimal.value.contains(".") {
            // round decimal
            var dec = convertedDecimal.decimalValue
            var decCopy = dec
            NSDecimalRound(&dec, &decCopy, 0, .down)
            convertedDecimal.setNewDecimal(with: dec)
        }
        
        // multiple by -1
        let newDecimalValue = -1 * convertedDecimal.decimalValue
        
        // ======================
        // Convert Decimal to Any
        // ======================
        let newDecimal = DecimalSystem(newDecimalValue)
        // convert to system value if not decimal
        if system != .dec {
            if let negatedValue = converter.convertValue(value: newDecimal, from: .dec, to: system) {
                return negatedValue
            } else {
                // if return nil
                return value
            }
        // for decimal return newDecimal
        } else {
            return newDecimal
        }
    }
    
    // Shift to needed bit count
    public func shiftBits( value: NumberSystemProtocol, mainSystem: ConversionSystemsEnum, shiftOperation: CalcMath.MathOperation, shiftCount: Int ) -> NumberSystemProtocol? {
        // Check if value is not float
        guard !value.value.contains(".") else {
            return value
        }
        
        // check if shift out of max bit index QWORD - 64
        // shifting more than 64 make no sense
        guard abs(shiftCount) < 64 else {
            // return 0
            return converter.convertValue(value: Binary(stringLiteral: "0"), from: .bin, to: mainSystem)
        }
        
        // convert to Binary
        let binary = converter.convertValue(value: value, from: mainSystem, to: .bin) as? Binary
        
        // check if binary is nil
        guard binary != nil else { return nil }
        
        // get operation
        let operation: CalcMath.MathOperation = {
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
    
        // loop shiftCount for x>>y and x<<y
        for _ in 0..<abs(shiftCount) {
            if operation == .shiftLeft {
                // <<
                // append from right
                binary!.value.append("0")
            } else if operation == .shiftRight {
                // >>
                // remove from right
                if binary!.value.count > 0 {
                    // remove right bit
                    binary!.value.removeLast(1)
                    // add left bit
                    if binary!.isSigned {
                        binary!.value = "1" + binary!.value
                    } else {
                        binary!.value = "0" + binary!.value
                    }
                } else {
                    binary!.value = "0"
                }
            } else {
                // if wrong operation
                binary!.value = "0"
            }
        }
        
        return converter.convertValue(value: Binary(stringLiteral: binary!.value), from: .bin, to: mainSystem)
    }
    
    // AND
    private func bitAnd(left: Binary, right: Binary) -> Binary {
        
        let resultBin = bitOperation(left: left, right: right) { reversedLeftBin, reversedRightBin in
            var resultStr = String()
            for index in 0..<reversedLeftBin.count {
                if reversedLeftBin[index] == "1" && reversedLeftBin[index] == reversedRightBin[index] {
                    resultStr.append("1")
                } else {
                    resultStr.append("0")
                }
            }
            return resultStr
        }
        
        return resultBin
    }
    
    // OR
    private func bitOr(left: Binary, right: Binary) -> Binary {
        
        let resultBin = bitOperation(left: left, right: right) { reversedLeftBin, reversedRightBin in
            var resultStr = String()
            for index in 0..<reversedLeftBin.count {
                if reversedLeftBin[index] == "1" || reversedRightBin[index] == "1" {
                    resultStr.append("1")
                } else {
                    resultStr.append("0")
                }
            }
            return resultStr
        }
        
        return resultBin
    }
    
    // XOR
    private func bitXor(left: Binary, right: Binary) -> Binary {
        
        let resultBin = bitOperation(left: left, right: right) { reversedLeftBin, reversedRightBin in
            var resultStr = String()
            for index in 0..<reversedLeftBin.count {
                if reversedLeftBin[index] != reversedRightBin[index] {
                    resultStr.append("1")
                } else {
                    resultStr.append("0")
                }
            }
            return resultStr
        }
        
        return resultBin
    }
    
    // Universal bit operation with input logic of looping reversed bits
    private func bitOperation(left: Binary, right: Binary, logic: ([Character],[Character]) -> String ) -> Binary {
        let resultBin = Binary()
        var resultStr = String()
        let wordSizeValue = wordSizeStorage.getWordSizeValue()
        
        // fill binarys for wordSize
        if left.value != right.value {
            left.value = left.fillUpZeros(str: left.value, to: wordSizeValue)
            right.value = right.fillUpZeros(str: right.value, to: wordSizeValue)
        }
        // reverse bin values
        let reversedLeftBin = left.value.reversed() as [Character]
        let reversedRightBin = right.value.reversed() as [Character]
        // loop bits with given logic
        resultStr = logic(reversedLeftBin,reversedRightBin)
        
        // set value to resultBin
        resultBin.value = String(resultStr.reversed())
        
        return resultBin
    }
    
    
    // universal func for converting dec to bin, calculating and returning new dec
    private func calculateBitOperation(firstNum: DecimalSystem, secondNum: DecimalSystem, operation: (Binary,Binary)->Binary ) -> DecimalSystem {
        // Check if value is not float
        guard !firstNum.value.contains(".") else {
            return firstNum
        }
        // Convert values to binary
        let binFirstNum = converter.convertValue(value: firstNum, from: .dec, to: .bin) as! Binary
        let binSecondNum = converter.convertValue(value: secondNum, from: .dec, to: .bin) as! Binary
        // do closure operation
        let binResult = operation(binFirstNum,binSecondNum)
        return converter.convertValue(value: binResult, from: .bin, to: .dec)! as! DecimalSystem
    }
    
    
}
