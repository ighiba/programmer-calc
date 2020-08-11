//
//  Binary.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

extension MainConverter {
    // ======
    // Binary
    // ======
    
    // BIN -> DEC
    func convertBinToDec( binNumStr: String) -> String {
        var resultStr: String
        
        // if zero
        guard binNumStr != "0" else {
            return "0"
        }
        
        // remove all spaces
        let str = removeAllSpaces(str: binNumStr)
     
        // Dividing to int and fract parts
        let buffDividedStr = divideToDoubleInt(str: str)
        let binIntStrBuff = buffDividedStr.0
        
        var buffInt = 0
        var buffDecimal: Decimal = 0.0
        var counter = 0
       
        guard binIntStrBuff != nil else {
            return "Error"
        }
        
        // First: converting int part
        // constructing Int
        // TODO: Error handling
        if let number = Int(binIntStrBuff!, radix: 2) {
            buffInt = number
        } else {
            buffInt = 0
        }
        
        // Second: converting fract part
        if let binFractStrBuff = buffDividedStr.1 {
            // if fract == 0 then dont calc it
            guard Int(binFractStrBuff) != 0 else {
                resultStr = "\(buffInt).0"
                return resultStr
            }
            
            counter = 1
            
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
            resultStr = "\(Decimal(buffInt) + buffDecimal)"
            return resultStr
            
        } else {
            // return int
            resultStr = "\(buffInt)"
            return resultStr
        }
    }
    
    // DEC -> BIN
    func convertDecToBinary( decNumStr: String) -> String {
        var decNumStrBuff = decNumStr
        var isSigned: Bool = false
        var binaryStr: String
        
        // if number is signed
        if decNumStr.contains("-") {
            let minusIndex = decNumStr.firstIndex(of: "-")
            decNumStrBuff.remove(at: minusIndex!)
            isSigned = true
        }
        
        if let decNumInt: Int = Int(decNumStrBuff) {
            binaryStr = convertIntToBinary(number: decNumInt)
        } else {
            // TODO   Error handling
            let splittedDoubleStr: (String?, String?) = divideToDoubleInt(str: decNumStrBuff)
            binaryStr = convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            
        }
        
        // handle minus sign and invert value
        if isSigned {
            // reverse 1 and 0 values
            var binaryStrBuff: String = String()
            binaryStr.forEach { (char) in
                switch char {
                case "0":
                    binaryStrBuff.append("1")
                    break
                case "1":
                    binaryStrBuff.append("0")
                    break
                default:
                    binaryStrBuff.append(char)
                    break
                }
            }
            
            // add 1 to beginning and replace binaryStr
            binaryStrBuff = "1" + binaryStrBuff
            binaryStr = binaryStrBuff
            
            // TODO: Delete end zeros for float binary nums
        }
      
        print(binaryStr)
        
        return binaryStr
    }
    
    // Converter for number before the point
    func convertIntToBinary( number: Int) -> String {
//        var divisible: Int = number
//        var reminder: Int = 0
//        var resultStr: String = String()
//
//        // divide by 2
//        while divisible != 0 && divisible != 1 {
//            reminder = divisible % 2
//            divisible = divisible / 2
//            resultStr.append(contentsOf: String(reminder))
//        }
//
//        // if no divide
//        if divisible == 0 || divisible == 1 {
//            resultStr.append(contentsOf: String(divisible))
//            resultStr = String(resultStr.reversed())
//        }
//
//        // divide it by parts with 4 digits each
//        if resultStr.count >= 1 && resultStr != "0" {
//            resultStr = String(resultStr.reversed())
//            resultStr = divideStr(str: resultStr, by: 4)
//            resultStr = String(resultStr.reversed())
//        }
        var resultStr = String(number, radix: 2)
        
        // divide it by parts with 4 digits each
        if resultStr.count >= 1 && resultStr != "0" {
            resultStr = String(resultStr.reversed())
            resultStr = divideStr(str: resultStr, by: 4)
            resultStr = String(resultStr.reversed())
        }

        return resultStr
    }
    
    func convertFractToBinary( numberStr: String, precision: Int) -> String {
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
            // remove ending zeros
//            while resultStr[resultStr.index(before: resultStr.endIndex)] == "0" && resultStr.count > 1 {
//                resultStr.remove(at: resultStr.index(before: resultStr.endIndex))
//            }
        }
        
        resultStr = divideStr(str: resultStr, by: 4)
        
        print(resultStr)
        return resultStr
    }
    
    // Combine to parts to double string
    func convertDoubleToBinaryStr( numberStr: (String?, String?)) -> String {
        // Error handling
        guard numberStr.0 != nil else {
            return "Error"
        }
        guard numberStr.1 != nil else {
            return "Error"
        }
        let intNumber = Int(numberStr.0!)!
        
        return "\(convertIntToBinary(number: intNumber)).\(convertFractToBinary(numberStr: numberStr.1!, precision: Int(SavedData.conversionSettings?.numbersAfterPoint ?? 8)))"
    }
    
    // Dividing string variable and converting it to double without loss of precision
    func divideToDoubleInt( str: String) -> (String?, String?) {
        
        var strInt: String
        var strFract: String

        // search index of floating pos
        if let pointPos = str.firstIndex(of: ".") {
            // fill strInt
            strInt = String(str[str.startIndex..<pointPos])
               
            // fill strFract
            strFract = String(str[pointPos..<str.endIndex])
            // delete .
            strFract.remove(at: strFract.startIndex)
            
            print(" \(strInt)...\(strFract)")
            return (strInt, strFract)
 
        } else {
            // if is int
            print("no float, return int and nil")
            return (str, nil)
        }

    }
    
    
    
}
