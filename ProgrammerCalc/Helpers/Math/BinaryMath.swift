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
        
        // process signed numbers
        var firstBinBit = String()
        var secondBinBit = String()
        
        // TODO: Refactor to closure?
        // Remove signed bits if processing signed values
        if let data = SavedData.calcState?.processSigned {
            if data {
                // replace to zeros
                firstBinBit = String(firstBin.value.first!)
                firstBin.value.removeFirst()
                firstBin.value = "0" + firstBin.value
                
                secondBinBit = String(secondBin.value.first!)
                secondBin.value.removeFirst()
                secondBin.value = "0" + secondBin.value
            }
        }

        // Make values equal (by lenght)
        let equaled = numberOfDigitsEqual(firstValue: firstBin.value, secondValue: secondBin.value)
        
        var firstBinary = equaled.0
        var secondBinary = equaled.1
        
        // Return signed bits after equaling by lenght
        if let data = SavedData.calcState?.processSigned {
            if data {
                firstBinary.removeFirst()
                firstBinary = firstBinBit + firstBinary
                
                secondBinary.removeFirst()
                secondBinary = secondBinBit + secondBinary
                
                // calcualte signed state
                firstBin.updateSignedState(for: firstBin)
                secondBin.updateSignedState(for: secondBin)
            }
        }
        
        firstBin.value = firstBinary
        secondBin.value = secondBinary
        
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
        
        var firstBinary = firstValue.value
        var secondBinary = secondValue.value
        
        // Preprocessing
        // Switch cases of addition
        switch (firstValue.isSigned, secondValue.isSigned) {
        // Case -x + y
        case (true, false):
            firstBinary = invertBinary(binary: firstBinary)
        // Case x + (-y)
        case (false, true):
            secondBinary = invertBinary(binary: secondBinary)
        // Case -x + (-y)
        case (true, true):
            firstBinary = invertBinary(binary: firstBinary)
            secondBinary = invertBinary(binary: secondBinary)
        default:
            break
        }
        
        // Calculation
        // Do addition
        resultBin.value = doSimpleAddition(firstValue: firstBinary, secondValue: secondBinary)
        // update value
        resultBin.updateSignedState(for: resultBin)
        
        // Postprocessing
        // Switch cases of addition
        switch (firstValue.isSigned, secondValue.isSigned) {
        // Case -x + y
        // Case x + (-y)
        case (true, false), (false, true):
            if resultBin.isSigned {
                let oneBit = resultBin.fillUpParts(str: "1", by: resultBin.value.count)
                resultBin.value = doSimpleAddition(firstValue: resultBin.value, secondValue: oneBit)
                
                resultBin.value.removeFirst()
                resultBin.value = "0" + resultBin.value
            } else {
                resultBin.value = invertBinary(binary: resultBin.value)
            }
            return resultBin
        // Case -x + (-y)
        case (true, true):
            if resultBin.isSigned {
                let oneBit = resultBin.fillUpParts(str: "1", by: resultBin.value.count)
                resultBin.value = doSimpleAddition(firstValue: resultBin.value, secondValue: oneBit)
                
                resultBin.value = invertBinary(binary: resultBin.value)
                resultBin.value.removeFirst()
                resultBin.value = "1" + resultBin.value
            } else {
                resultBin.value = invertBinary(binary: resultBin.value)
            }
            return resultBin
        default:
            break
        }
        
        return resultBin
    }
    
    fileprivate func doSimpleAddition( firstValue: String, secondValue: String) -> String {
        var result = String()
        var reminder = 0
        
        var firstBinary = firstValue
        var secondBinary = secondValue
        
        // Do addition
        while firstBinary != "" {
            let firstLast = String(firstBinary.last!)
            let secondLast = String(secondBinary.last!)
            
            // if point then new iteration
            guard firstLast != "." && secondLast != "." else {
                result = "." + result
                firstBinary.removeLast()
                secondBinary.removeLast()
                continue
            }
            // calculate ints
            let intBuff = Int(firstLast)! + Int(secondLast)! + reminder
            // process calculation result
            switch intBuff {
            case 0:
                result = "0" + result
                break
            case 1:
                result = "1" + result
                reminder = 0
                break
            case 2:
                result = "0" + result
                reminder = 1
                break
            case 3:
                result = "1" + result
                reminder = 1
            default:
                break
            }
            
            firstBinary.removeLast()
            secondBinary.removeLast()
        }
        
        // add last reminder if not 0
        if reminder == 1 {
            result = "1" + result
        }
        
        return result
    }
    
    // Subtraction of binary numbers
    public func subBinary(_ firstValue: Binary, _ secondValue: Binary) -> Binary {
        var resultBin = Binary()
        
        // if x - x = 0
        if firstValue.value == secondValue.value {
            return "0"
        }
        
        // Switch cases of subtraction
        switch (firstValue.isSigned, secondValue.isSigned) {
        // Case -x - y
        case (true, false):
            // change signed to 0
            firstValue.value = changeSignedBit(binary: firstValue, to: "0")
            firstValue.updateSignedState(for: firstValue)
            resultBin = addBinary(firstValue, secondValue)
            resultBin.isSigned = firstValue.isSigned
            // fill up if need
            resultBin.fillUpSignedToNeededCount()
            // make negative
            resultBin.value = changeSignedBit(binary: resultBin, to: "1")
            resultBin.updateSignedState(for: resultBin)

            return resultBin
        // Case x - (-y)
        case (false, true):
            // change signed to 0
            secondValue.value = changeSignedBit(binary: secondValue, to: "0")
            secondValue.updateSignedState(for: secondValue)
            resultBin = addBinary(firstValue, secondValue)
            resultBin.isSigned = firstValue.isSigned
            // fill up if need
            resultBin.fillUpSignedToNeededCount()

            return resultBin
        // Case -x - (-y)
        case (true, true):
            // change signed bit to 0 for second value -(-y) == +y
            firstValue.value = changeSignedBit(binary: firstValue, to: "1")
            secondValue.value = changeSignedBit(binary: secondValue, to: "0")
            
            // fill up if need
            if secondValue.value.count < firstValue.value.count {
                // remove signed bit
                secondValue.value.removeFirst()
                secondValue.value = secondValue.fillUpParts(str: secondValue.value, by: firstValue.value.count)
                // remove left dummy signed bit
                // return sign bit from beginning
                secondValue.value = changeSignedBit(binary: secondValue, to: "0")
            } else {
                // remove signed bit
                firstValue.value.removeFirst()
                firstValue.value = firstValue.fillUpParts(str: firstValue.value, by: secondValue.value.count)
                // remove left dummy signed bit
                // return sign bit from beginning
                firstValue.value = changeSignedBit(binary: firstValue, to: "1")
            }
            
            firstValue.updateSignedState(for: firstValue)
            secondValue.updateSignedState(for: secondValue)
            // add like - x = y
            resultBin = addBinary(firstValue, secondValue)
            
            resultBin.updateSignedState(for: resultBin)
            
            return resultBin

        // Default case x - y
        case (false, false):
            // Inverting second value
            secondValue.value = invertBinary(binary: secondValue.value)
            
            // Subtracting secondValue from firstValue
            // Add first value + inverterd second value
            resultBin = addBinary(firstValue, secondValue)
            
            // Delete left bit
            if resultBin.value.count > firstValue.value.count {
                // unsigned
                resultBin.value.removeFirst()
                // Add + 1 for additional code
                let oneBit = resultBin.fillUpParts(str: "1", by: resultBin.value.count)
                resultBin.value = doSimpleAddition(firstValue: resultBin.value, secondValue: oneBit)
            } else {
                // signed
                // update signed status
                resultBin.updateSignedState(for: resultBin)
                
                // delete signed bit
                resultBin.value.removeFirst()
                
                // invert from reverse code to normal
                resultBin.value = invertBinary(binary: resultBin.value)
                
                // add signed bit
                if resultBin.isSigned {
                    resultBin.value = "1" + resultBin.value
                } else {
                    resultBin.value = "0" + resultBin.value
                }
            }
        }
        
        // returns in normal code
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
    
    private func changeSignedBit( binary: Binary, to digit:String) -> String {
        // remove signed bit
        binary.value.removeFirst()
        // add signed bit inpud digit
        binary.value = digit + binary.value
        
        return binary.value
    }
    
}
