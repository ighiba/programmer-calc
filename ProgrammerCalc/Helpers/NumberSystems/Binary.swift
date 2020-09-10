//
//  Binary.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 13.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

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
        // TODO: Handle signed 
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

    
    // ===============
    // MARK: - Methods
    // ===============
    
    // only for int or fract part of binary
    func removeZerosBefore( str: String) -> String {
        var resultStr = str
        
        // delete first zero
        while resultStr.first == "0" && resultStr.count != 1 {
            resultStr.removeFirst()
        }
        
        return resultStr
    }
    
    // remove zeros after until point and deletes point if no more digits after it
    func removeZerosAfter( str: String) -> String {
        var resultStr = str
        
        if resultStr.contains(".") && resultStr.last != "." {
            // delete zeros
            while resultStr.last == "0" && resultStr.last != "." {
                resultStr.removeLast()
            }
            // delete point if last
            if resultStr.last == "." {
                resultStr.removeLast()
            }
        }
        
        return resultStr
    }
    
    // BIN -> DEC
    func convertBinaryToDec() -> Decimal {
        let binary = self
        
        var result: Decimal = 0.0
        
        // if zero
        guard binary.value != "0" else {
            return result
        }
        
        // remove all spaces
        let str = removeAllSpaces(str: binary.value)
     
        // Dividing to int and fract parts
        let buffDividedStr = divideIntFract(value: str)
        var binIntStrBuff = buffDividedStr.0
       
        guard binIntStrBuff != nil else {
            return 0.0
        }
        
        var signedMultipler: Decimal = 1 // default is unsigned value
        
        // First: converting int part
        ifProcessSigned {
            // calcualte signed state
            binary.updateSignedState() // changes binary.isSigned state to true of false
            
            // remove signed bit
            binIntStrBuff?.removeFirst()
            // set multipler to -1 or 1 for inverting value
            if binary.isSigned {
                signedMultipler = -1
            } else {
                signedMultipler = 1
            }
        }
        
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
            return result * signedMultipler
            
        }
        
        return result * signedMultipler
    }
    
    // BIN -> HEX
    // Convert form binary to hex with table helper
    func convertBinaryToHex( hexTable: [String : String]) -> Hexadecimal {
        let binary = self
        let hexadecimal = Hexadecimal()
        
        // handle signed values
        ifProcessSigned {
            // update signed state and change signed bit to 0
            binary.updateSignedState()
            //binary.changeSignedBit(to: "0")
            if binary.isSigned {
                // convert binary to twos complenment
                binary.twosComplement()
            }
        }
   
        let partition: Int = 4
        
        // TODO: Remove spaces
        
        var dividedBinary = divideIntFract(value: binary.value)
        
        // fill up to 3 or 4 digit in int part
        dividedBinary.0 = fillUpParts(str: dividedBinary.0!, by: partition)
        
        // from binary to oct
        // process each number and form parts
        hexadecimal.value = tableOctHexFromBin(valueBin: dividedBinary.0!, partition: partition, table: hexTable)
        
        guard dividedBinary.1 != nil else { return hexadecimal }
        
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
        let converterHandler = ConverterHandler()
         
        let partition: Int = 3
         
        // handle signed values
        ifProcessSigned {
            // update signed state and change signed bit to 0
            binary.updateSignedState()
            //binary.changeSignedBit(to: "0")
            if binary.isSigned {
                binary.value = converterHandler.toTwosComplement(valueStr: binary.value, mainSystem: "Binary")
            }
        }
        
        var dividedBinary = divideIntFract(value: binary.value)
        
        // fill up to 3 digit in int part
        dividedBinary.0 = fillUpParts(str: dividedBinary.0!, by: partition)
        
        // from binary to oct
        // process each number and form parts
        octal.value = tableOctHexFromBin(valueBin: dividedBinary.0!, partition: partition, table: octTable)
        
        guard dividedBinary.1 != nil else { return octal }
        
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

        return "0" + String(valueInt, radix: 2)
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
    
    // Filling up BINARY number with zeros by num of zeros in 1 part
    func fillUpParts( str: String, by fillNum: Int) -> String {
        // remove all spaces
        var buffStr = removeAllSpaces(str: str)
        
        if Int(buffStr) != 0 {
            // remove all zeros at beginning of string
            while buffStr.first == "0" {
                buffStr.removeFirst()
            }
            
            // if all zeros deleted
            if buffStr.first == "." {
                buffStr = str
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
            
            binary.value = removeAllSpaces(str: binary.value)

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
        
        guard diffInt > 0 else {return str}
        
        return String(repeating: "0", count: diffInt) + str
    }
    
    // Filling up zeros to needed count
    private func fillUpOne( str: String, to num: Int) -> String {
        let diffInt = num - str.count
        
        guard diffInt > 0 else {return str}
        
        return String(repeating: "1", count: diffInt) + str
    }
    
    
    // Fill up to needed format
    func fillToFormat( upToZeros signed:Bool) {
        let binary = self
        
        let neededCount: Int = {
            var maxBits: Int = 8 // default
            for power in 3...6 {
                // 2^3, 2^4 ....calculating bits
                let bits = Int(pow(2, Float(power)))
                // set maximum lenght for binary str
                if binary.value.count <= bits {
                    maxBits = bits
                    return maxBits
                }
            }
            return maxBits
        }()
        if signed {
            // -12 => 1100 -> 11111100
            // 10011000 -> 1111111110011000
            // fill up with zeros to needed bit position
            binary.value = fillUpZeros(str: binary.value, to: neededCount)
        } else {
            // 1100 -> 00001100
            // 10011000 -> 0000000010011000
            // fill up with one to needed bit position
            binary.value = fillUpOne(str: binary.value, to: neededCount)
        }
        
    }
    
    // Set fillig style for binary string
    private func fillingStyleResult(for str: String) -> String {
        let binary = self
        
        binary.value = str
        
        // remove spaces
        binary.value = removeAllSpaces(str: binary.value)
        
        // get saved data
        if let data = SavedData.calcState?.processSigned {
            // if .processSigned == true
            if data {
                // fill if needed to
                binary.fillToFormat(upToZeros: true)
                
                // calcualte signed state
                binary.updateSignedState() // changes binary.isSigned state to true of false
                
                // remove signed bit
                binary.value.removeFirst()
                
                // remove zeros before
                binary.value = binary.removeZerosBefore(str: binary.value)
                
                // fills up binary to 7, 15, 31, 63 + signed bit by self.isSigned
                // isSigned == true -> 1 else -> 0
                binary.fillUpSignedToNeededCount()
                
                return binary.value
            }
        }
        
        // just make binary code pretty
        binary.value = fillUpParts(str: binary.value, by: 4)
        
        return binary.value
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
            let buffStr = removeAllSpaces(str: fractPart)
            
            resultStr = resultStr + "." + buffStr
        }
        
        return resultStr
    }
    
    // Updating is signed state of binary
    func updateSignedState() {
        let binary = self
        if binary.value.first == "1" {
            binary.isSigned = true
        } else {
            binary.isSigned = false
        }
    }
    
    // Change leftiest bit (signed) to needed value and update state
    func changeSignedBit(to bit: Character) {
        let binary = self
        
        // if invalid input then do nothing
        guard (bit == "0") || (bit == "1") else {return}
        
        // remove leftiest bit
        binary.value.removeFirst()
        // add left bit
        binary.value = "\(bit)\(binary.value)"
        
    }
    
    // Filling up signed binary to power 2^3, 2^4 .. etc
    func fillUpSignedToNeededCount() {
        let binary = self
        
        // count how much zeros need to fill
        let neededCount: Int = {
            var maxBits: Int = 8 // default
            for power in 3...6 {
                // 2^3, 2^4 ....calculating bits
                let bits = Int(pow(2, Float(power)))
                // set maximum lenght for binary str
                if binary.value.count < bits {
                    maxBits = bits
                    return maxBits
                }
            }
            return maxBits
        }()
        // fill up with zeros to needed bit position
        binary.value = fillUpZeros(str: binary.value, to: neededCount-1)
        
        // add signed bit by signed state
        if binary.isSigned {
            binary.value = "1" + binary.value
        } else {
            binary.value = "0" + binary.value
        }
    }
    
    // Appending digit to end
    func appendDigit(_ digit: String) {
        let binary = self
        
        // just add digit if point exits
        guard digit != "." && !binary.value.contains(".") else {
            binary.value.append(digit)
            return
        }
        
        // if binary not float
        binary.value = binary.removeAllSpaces(str: binary.value)
        
        // get saved data
        if let data = SavedData.calcState?.processSigned {
            // if .processSigned == true
            if data {
                // calcualte signed state
                binary.updateSignedState() // changes binary.isSigned state to true of false
                
                // remove signed bit
                binary.value.removeFirst()
                
                // remove zeros before
                binary.value = binary.removeZerosBefore(str: binary.value)
                
                if binary.value == "0" {
                    // replace if 0
                    binary.value = digit
                } else {
                    // append digit
                    binary.value.append(digit)   
                }
                
                // fills up binary to 7, 15, 31, 63 + signed bit by self.isSigned
                // isSigned == true -> 1 else -> 0
                binary.fillUpSignedToNeededCount()
                
            } else {
                // if doesnt process signed binary values
                // just append
                binary.value.append(digit)
                
                // just make binary code pretty
                binary.value = fillUpParts(str: binary.value, by: 4)
            }
        }  
    }
    
    // inverting binary
    func invert() {
        let binary = self
        var buffStr = String()
        
        // process each bit
        binary.value.forEach { (bit) in
            switch bit {
            case "0":
                buffStr.append("1")
                break
            case "1":
                buffStr.append("0")
                break
            default:
                buffStr.append(bit)
                break
            }
        }
        // apply inversion
        binary.value = buffStr
    }
    
    public func onesComplement() {
        let binary = self
        var signedBit = String()
        
        // delete signed bit if exist
        ifProcessSigned {
            signedBit = String(binary.value.first!)
            binary.value.removeFirst()
        }
        // invert binary
        binary.invert()
        // return signed bit if exists
        binary.value = signedBit + binary.value
    }
    
    public func twosComplement() {
        let binary = self
        var signedBit = String()
        
        // convert to 1's complement
        binary.onesComplement()
        // save signed bit and change to 0
        binary.ifProcessSigned {
            signedBit = String(binary.value.first!)
            binary.updateSignedState()
            binary.changeSignedBit(to: "0")
        }

        // +1 for 2's complement
        let oneBit = Binary(stringLiteral: "1")
        binary.value = CalcMath().calculate(firstValue: binary.value, operation: .add, secondValue: oneBit.value, for: "Binary")!
        
        // return signed bit if exists
        if signedBit != "" {
            binary.changeSignedBit(to: Character(signedBit))
        }
    }
    
    fileprivate func doSimpleBinaryAddition( firstValue: String, secondValue: String) -> String {
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
            
            // calculate bits
            let intBuff = Int(firstLast)! + Int(secondLast)! + reminder
            
            // process calculation result
            switch intBuff {
                case 0:
                    result = "0" + result
                case 1:
                    result = "1" + result
                    reminder = 0
                    break
                case 2:
                    result = "0" + result
                    reminder = 1
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

}
