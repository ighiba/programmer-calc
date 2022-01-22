//
//  HelpersMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

// Error types
enum MathErrors: Error, CaseIterable {
    case divByZero
}

extension MathErrors: LocalizedError {
    // Error localization
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
    
    private let wordSize: WordSize = WordSize.shared
    
    // Object "Converter"
    let converter: Converter = Converter()
    
    enum Operation {
        // arithmetic
        case add
        case sub
        case mul
        case div
        // bitwise
        case shiftLeft //  <<
        case shiftRight //  >>
        case shiftLeftBy //  X << Y
        case shiftRightBy // X >> Y
        // logical
        case and
        case or
        case xor
        case nor
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    func calculate( firstValue: NumberSystemProtocol, operation: Operation ,secondValue: NumberSystemProtocol, for system: ConversionSystemsEnum) throws -> NumberSystemProtocol? {
  
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let firstConverted: DecimalSystem
        let secondConverted: DecimalSystem
        
        // Check if values is DecimalSystem
        // If not then convert to DecimalSystem
        if !(firstValue is DecimalSystem) || !(secondValue is DecimalSystem) {
            firstConverted = converter.convertValue(value: firstValue, to: .dec, format: true)! as! DecimalSystem
            secondConverted = converter.convertValue(value: secondValue, to: .dec, format: true)! as! DecimalSystem
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
        let formattedBin = converter.convertValue(value: newDecimal!, to: .bin, format: true)
        // convert to decimal from bin
        let formattedDec = converter.convertValue(value: formattedBin!, to: .dec, format: true) as! DecimalSystem
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
            return converter.convertValue(value: formattedDec, to: system, format: true)
        } else {
            return formattedDec
        }
   
    }
    
    // Calculation of 2 decimal numbers by .operation
    fileprivate func calculateDecNumbers( firstNum: DecimalSystem, secondNum: DecimalSystem, operation: CalcMath.Operation) throws -> DecimalSystem? {
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

            if let dec = shiftBits(number: firstNum, mainSystem: .dec, shiftOperation: .shiftLeft, shiftCount: DecimalSystem(1)) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
            }
            
        // Bitwise shift right
        case .shiftRight:
            
            if let dec = shiftBits(number: firstNum, mainSystem: .dec, shiftOperation: .shiftRight, shiftCount: DecimalSystem(1)) as? DecimalSystem {
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
            if let dec = shiftBits(number: firstNum, mainSystem: .dec, shiftOperation: .shiftLeft, shiftCount: secondNum) as? DecimalSystem {
                resultStr = dec.value
            } else {
                return firstNum
            }
        case .shiftRightBy:
            if let dec = shiftBits(number: firstNum, mainSystem: .dec, shiftOperation: .shiftRight, shiftCount: secondNum) as? DecimalSystem {
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
        
        
        // fill up bits (0) to current word size
        resultStr = fillUpZeros(str: resultStr, to: wordSize.value)
        
        return resultStr
    }
    
    public func negate(value: NumberSystemProtocol, system: ConversionSystemsEnum) -> NumberSystemProtocol {
        // ======================
        // Convert Any to Decimal
        // ======================
        
        let convertedDecimal = converter.convertValue(value: value, to: .dec, format: true)! as! DecimalSystem
        
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
            if let negatedValue = converter.convertValue(value: newDecimal, to: system, format: true) {
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
    public func shiftBits(number: NumberSystemProtocol,
                          mainSystem: ConversionSystemsEnum,
                          shiftOperation: CalcMath.Operation,
                          shiftCount: DecimalSystem ) -> NumberSystemProtocol? {
        // Check if value is not float
        guard !number.value.contains(".") else {
            return number
        }
        
        // check if shift out of max bit index QWORD - 64
        // shifting more than 64 make no sense
        guard shiftCount.decimalValue < 64 && shiftCount.decimalValue > -64 else {
            // return 0
            return converter.convertValue(value: Binary(0), to: mainSystem, format: true)
        }
        
        // convert shift count to absolute int
        let absoluteShiftCount = (abs(shiftCount.decimalValue) as NSDecimalNumber).intValue
        
        // convert to Binary
        guard let binary = converter.convertValue(value: number, to: .bin, format: true) as? Binary else {
            return nil
        }

        // get operation
        let operation: CalcMath.Operation = {
            if shiftCount.decimalValue < 0 {
                // swap operation if shift count < 0
                return shiftOperation == .shiftRight ? .shiftLeft : .shiftRight
            } else {
                // keep input value if shift count > 0
                return shiftOperation
            }
        }()
    
        // loop shiftCount for x>>y and x<<y
        for _ in 0..<absoluteShiftCount {
            switch operation {
            case .shiftLeft:
                // <<
                binary.shiftOneLeft()
            case .shiftRight:
                // >>
                binary.shiftOneRight()
            default:
                // if wrong operation
                binary.value = "0"
            }
        }
        
        return converter.convertValue(value: Binary(stringLiteral: binary.value), to: mainSystem, format: true)
    }
    
    // AND
    private func bitAnd(left: Binary, right: Binary) -> Binary {
        return bitOperation(left: left, right: right) { leftBit, rightBit in
            compareBitsAnd(leftBit, rightBit)
        }
    }
    
    // OR
    private func bitOr(left: Binary, right: Binary) -> Binary {
        return bitOperation(left: left, right: right) { leftBit, rightBit in
            compareBitsOr(leftBit, rightBit)
        }
    }
    
    // XOR
    private func bitXor(left: Binary, right: Binary) -> Binary {
        return bitOperation(left: left, right: right) { leftBit, rightBit in
            compareBitsXor(leftBit, rightBit)
        }
    }
    
    // Universal bit operation with input bit comparison logic closure
    private func bitOperation(left: Binary, right: Binary, comparison: (Character, Character) -> Bool ) -> Binary {
        let resultBin = Binary()
        var resultStr = String()
    
        
        // fill binarys for wordSize
        if left.value != right.value {
            left.value = left.fillUpZeros(str: left.value, to: wordSize.value)
            right.value = right.fillUpZeros(str: right.value, to: wordSize.value)
        }
        // reverse bin values
        let reversedLeftBin = left.value.reversed() as [Character]
        let reversedRightBin = right.value.reversed() as [Character]
        
        // loop bits with given comparison logic closure
        for i in 0..<reversedLeftBin.count {
            let condition = comparison(reversedLeftBin[i], reversedRightBin[i])
            let bit = getBitBy(cond: condition)
            resultStr.append(bit)
        }
        
        // set value to resultBin
        resultBin.value = String(resultStr.reversed())
        
        return resultBin
    }
    
    private func getBitBy(cond: Bool) -> String {
        return cond ? "1" : "0"
    }
    
    private func compareBitsAnd(_ leftBit: Character, _ rightBit: Character) -> Bool {
        return leftBit == "1" && leftBit == rightBit
    }
    
    private func compareBitsOr(_ leftBit: Character, _ rightBit: Character) -> Bool {
        return leftBit == "1" || rightBit == "1"
    }
    
    private func compareBitsXor(_ leftBit: Character, _ rightBit: Character) -> Bool {
        return leftBit != rightBit
    }
    
    
    // universal func for converting dec to bin, calculating and returning new dec
    private func calculateBitOperation(firstNum: DecimalSystem, secondNum: DecimalSystem, operation: (Binary,Binary)->Binary ) -> DecimalSystem {
        // Check if value is not float
        guard !firstNum.value.contains(".") else {
            return firstNum
        }
        // Convert values to binary
        let binFirstNum = converter.convertValue(value: firstNum, to: .bin, format: true) as! Binary
        let binSecondNum = converter.convertValue(value: secondNum, to: .bin, format: true) as! Binary
        // do closure operation
        let binResult = operation(binFirstNum,binSecondNum)
        return converter.convertValue(value: binResult, to: .dec, format: true) as! DecimalSystem
    }
    
    
}
