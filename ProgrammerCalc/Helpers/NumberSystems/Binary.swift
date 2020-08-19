//
//  Binary.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 13.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

// ======
// Binary
// ======

class Binary: NumberSystem {
    
    required public init(stringLiteral value: String) {
        super.init(stringLiteral: value)
        
        // process string input and apply style for output
        self.value = processStringInput(str: value)
    }
    
    /// Creates an empty instance
    override init() {
        super.init()
    }
    
    /// Creates an instance initialized to the Int value
    init(_ valueInt: Int) {
        super.init()
        self.value = String(valueInt, radix: 2)
        self.value = fillUpParts(str: self.value, by: 4)
    }
    
    /// Creates an instance initialized to the Decimal value
    convenience init(_ valueDec: Decimal) {
        self.init()
        let binary = valueDec.convertDecToBinary()
        super.value = binary.value
    }
    
    /// Creates an instance initialized to the Hexadecimal value
    init(_ valueHex: Hexadecimal) {
        super.init()
        let binary = valueHex.convertHexToBinary()
        self.value = binary.value
        
    }
    
    /// Creates an instance initialized to the Octal value
    init(_ valueOct: Octal) {
        super.init()
        let binary = valueOct.convertOctToBinary()
        self.value = binary.value
        
    }

    
    // =======
    // Methods
    // =======
    
    
    // BIN -> DEC
    func convertBinaryToDec() -> Decimal {
        let binNumStr = super.value
        
        var result: Decimal = 0.0
        
        // if zero
        guard binNumStr != "0" else {
            return result
        }
        
        // remove all spaces
        let str = removeAllSpaces(str: binNumStr)
     
        // Dividing to int and fract parts
        let buffDividedStr = divideIntFract(value: str)
        let binIntStrBuff = buffDividedStr.0
       
        guard binIntStrBuff != nil else {
            return 0.0
        }
        
        // First: converting int part
        // constructing Int
        // TODO: Error handling
        if let number = Int(binIntStrBuff!, radix: 2) {
            result += Decimal(integerLiteral: number)
        } else {
            result = 0.0
        }
        
        // Second: converting fract part
        if let binFractStrBuff = buffDividedStr.1 {
            // if fract == 0 then dont calc it
            guard Int(binFractStrBuff) != 0 else {
                return result
            }
            
            var counter = 1
            var buffDecimal: Decimal = 0.0
            
            binFractStrBuff.forEach { (num) in
                // TODO: Error handling
                let buffInt = Int("\(num)")!
                let buffIntDecimal = Decimal(integerLiteral: buffInt)
                // 1 * 2^-n
                let buffValue: Decimal = buffIntDecimal *  ( 1.0 / pow(2 as Decimal, counter))
                
                buffDecimal += buffValue
                
                counter += 1
            }
            // return decimal if second value after dividing is nil
            result += buffDecimal
            return result
            
        }
        
        return result
    }
    
    // BIN -> HEX
    // Convert form binary to hex with table helper
    func convertBinaryToHex( hexTable: [String : String]) -> Hexadecimal {
        let binary = self
        let hexadecimal = Hexadecimal()
        
        
        let partition: Int = 4
        
        // TODO: Remove spaces
        
        var dividedBinary = divideIntFract(value: binary.value)
        
        // fill up to 3 digit in int part
        dividedBinary.0 = fillUpParts(str: dividedBinary.0!, by: partition)
        
        // from binary to oct
        // process each number and form parts
        hexadecimal.value = tableOctHexFromBin(valueBin: dividedBinary.0!, partition: partition, table: hexTable)
        
        guard dividedBinary.1 != nil else {
            
            return hexadecimal
        }
        
        // fill up to 3 digit in fract part
        dividedBinary.1 = String(dividedBinary.1!.reversed())
        dividedBinary.1 = fillUpParts(str: dividedBinary.1!, by: partition)
        dividedBinary.1 = String(dividedBinary.1!.reversed())
        // process fract part
        hexadecimal.value += "."
        hexadecimal.value +=  tableOctHexFromBin(valueBin: dividedBinary.1!, partition: partition, table: hexTable)
        
        return hexadecimal
    }
    
    // BIN -> OCT
    // Convert form binary to hex with table helper
    func convertBinaryToOct( octTable: [String : String]) -> Octal {
        let binary = self
        let octal = Octal()
         
        let partition: Int = 3
         
        // TODO: Remove spaces
        
        var dividedBinary = divideIntFract(value: binary.value)
        
        // fill up to 3 digit in int part
        dividedBinary.0 = fillUpParts(str: dividedBinary.0!, by: partition)
        
        // from binary to oct
        // process each number and form parts
        octal.value = tableOctHexFromBin(valueBin: dividedBinary.0!, partition: partition, table: octTable)
        
        guard dividedBinary.1 != nil else {
            
            return octal
        }
        
        // fill up to 3 digit in fract part
        dividedBinary.1 = String(dividedBinary.1!.reversed())
        dividedBinary.1 = fillUpParts(str: dividedBinary.1!, by: partition)
        dividedBinary.1 = String(dividedBinary.1!.reversed())
        // process fract part
        octal.value += "."
        octal.value +=  tableOctHexFromBin(valueBin: dividedBinary.1!, partition: partition, table: octTable)
         
        return octal
    }
    
    // Converting IntPart of Floating point binary
    func convertIntToBinary(_ valueInt: Int) -> IntPart {
        //var binaryStr = String(valueInt, radix: 2)
        
        //binaryStr = fillingStyleResult(for: binaryStr)

        return String(valueInt, radix: 2)
    }
    
    // Converting FractPart of Floating point binary
    func convertFractToBinary( numberStr: String, precision: Int) -> FractPart {
        var buffDouble: Double
        var buffStr: String = "0."
        var resultStr: String = String()
       
        // if 0 then dont calculate
        if Int(numberStr) == 0 {
            resultStr = "0"
        } else {
            // number of digits after point
            let counter: Int = precision
            // form double string
            buffStr.append(numberStr)
            buffDouble = Double(buffStr)!
                   
            // convert fract part of number
            // multiply by 2, if bigger then 1 then = 1, else 0
            for _ in 0..<counter {
                buffDouble = buffDouble * 2
                if buffDouble >= 1 {
                    resultStr.append("1")
                    buffDouble = buffDouble - 1
                } else {
                    resultStr.append("0")
                }
             }
        }
        
        return resultStr
    }
    
    
    // Combine to parts to double string
    func convertDoubleToBinaryStr( numberStr: (IntPart?, FractPart?)) -> String {
        
        // Error handling
        guard numberStr.0 != nil else {
            return "Error"
        }
        guard numberStr.1 != nil else {
            return "Error"
        }
        
        let intNumber = Int(numberStr.0!)!
        let precision = Int(SavedData.conversionSettings?.numbersAfterPoint ?? 8)
        let intPart = convertIntToBinary(intNumber)
        let fractPart = convertFractToBinary(numberStr: numberStr.1!, precision: precision)
        
        
        return "\(intPart).\(fractPart)"
    }
    
    // filling up BINARY number with zeros by num of zeros in 1 part
    func fillUpParts( str: String, by fillNum: Int) -> String {
        // remove all spaces
        var buffStr = removeAllSpaces(str: str)
        
        if Int(buffStr) != 0 {
            // remove all zeros at beginning of string
            while buffStr.first == "0" {
                buffStr.removeFirst()
            }
        } else {
            // if zero then return fillNum zeros
            buffStr = ""
            for _ in 1...fillNum {
                buffStr.append("0")
            }
            
            return buffStr
        }
        
        var counter = 0
        // count how much 0 is need for filling
        buffStr.forEach({ (num) in
            if counter == fillNum - 1 {
                    counter = 0
                } else {
                    counter += 1
                }
            })
        
        // add zeros after for filling the parts
        if counter > 0 {
            for _ in 0...fillNum-counter-1 {
                buffStr = "0" + buffStr
            }
        }

        return buffStr
    }
    
    // Divide number by parts
    func divideBinary( by partition: Int) -> Binary {
        let binary = self
        var buffStr = String()

        // if count of digits more than or equal to 1 AND number not 0
        if binary.value.count >= 1 && binary.value != "0" {
            var counter: Int = 0

            for char in binary.value {
                // check if already point
                if char == "." {
                    counter = 0
                    buffStr.append(char)
                    continue
                }
                // if ok
                if counter == partition-1 {
                    buffStr.append("\(char) ")
                    counter = 0
                } else {
                    buffStr.append(char)
                    counter += 1
                }
            }

            // add zeros after for filling the parts
//            if counter > 0 {
//                for _ in 0...partition-counter-1 {
//                    buffStr.append("0")
//                }
//            }

            // delete space before and after .
            if buffStr.contains(".") {
                var pointPos = buffStr.firstIndex(of: ".")!

                var pointBuff = buffStr.index(before: pointPos)

                // delete space before if exists
                if buffStr[pointBuff] == " " {
                    buffStr.remove(at: pointBuff)
                }

                // if . isn't last element
                if buffStr.last != "." {
                    // update indexes
                    pointPos = buffStr.firstIndex(of: ".")!
                    pointBuff = buffStr.index(after: pointPos)
                        // delete space after if exists
                    if buffStr[pointBuff] == " " {
                        buffStr.remove(at: pointBuff)
                    }
                }
            }
            binary.value = buffStr
        }

        // remove first and last spaces
        if binary.value.first == " " {
            binary.value.remove(at: binary.value.startIndex)
        }
        if binary.value.last == " " {
            binary.value.remove(at: binary.value.index(before: binary.value.endIndex))
        }

        return binary
    }
    
    // Filling up zeros to needed count
    private func fillUpZeros( str: String, to num: Int) -> String {
        let diffInt = num - str.count
        
        return String(repeating: "0", count: diffInt) + str
    }
    
    // Set fillig style for binary string
    private func fillingStyleResult(for str: String) -> String {
        var binaryStr = str
        // get saved data
        if let data = SavedData.calcState?.processSigned {
            // if .processSigned == true
            if data {
                // count how much zeros need to fill
                let neededCount: Int = {
                    var maxBits: Int = 8 // default
                    for power in 3...6 {
                        // 2^3, 2^4 ....calculating bits
                        let bits = Int(pow(2, Float(power)))
                        // set maximum lenght for binary str
                        if binaryStr.count < bits {
                            maxBits = bits
                            return maxBits
                        }
                    }
                    return maxBits
                }()
                // fill up with zeros to needed bit position
                binaryStr = fillUpZeros(str: binaryStr, to: neededCount)
            } else {
                // just make binary code pretty
                binaryStr = fillUpParts(str: binaryStr, by: 4)
            }
        } else {
            // just make binary code pretty
            binaryStr = fillUpParts(str: binaryStr, by: 4)
        }
        
        return binaryStr
    }
    
    func handleSigned() {
        self.value.removeFirst()
    }
    
    
    // Processing strings that initialized from stringLiteral
    fileprivate func processStringInput( str: String) -> String {
        let binaryDivided = self.divideIntFract(value: str)
        var resultStr = String()
        
        // process int part
        if let intPart = binaryDivided.0 {
            // apply style to input
            // signed or not
            resultStr += fillingStyleResult(for: intPart)
        }
        
        // process fract part
        if let fractPart = binaryDivided.1 {
            resultStr = "." + fractPart
        }
        
        return resultStr
    }
    
}
