//
//  NumberSystem.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class NumberSystem: ExpressibleByStringLiteral {
    // for divided numbers
    typealias IntPart = String
    typealias FractPart = String
    
    
    // raw value
    var value: String

    required public init(stringLiteral value: String) {
        self.value = value
    }

    /// Creates an empty instance
    init() {
        self.value = ""
    }

    /// Creates an instance initialized to the Binary value
    init(_ valueBin: Binary) {
        // do convert here
        self.value = valueBin.value
    }
    
    
    // =======
    // Methods
    // =======
    
    // Dividing string variable and converting it to double without loss of precision
    func divideIntFract( value: Any) -> (IntPart?, FractPart?) {
        let str = String(describing: value)
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
    
    // ====================
    // Hexadecimal // Octal
    // ====================
    
    // Parsing tables dictionary hex or oct for converting to bin
    func tableOctHexToBin( valueOctHex: String, table: [String : String]) -> String {
        var resultStr = String()
        
        // from hex or oct to binary
        // process each number and form parts
        valueOctHex.forEach { (num) in
            if num != "." {
                for (key, value) in table {
                    if "\(num)" == value {
                        // append balue from table
                        resultStr.append("\(key)")
                        break
                    }
                }
            } else {
                // append .
                resultStr.append(num)
            }
        }
        
        return resultStr
    }
    
    // Parsing tables dictionary bin for converting to hex or oct
    func tableOctHexFromBin( valueBin: String, partition: Int, table: [String : String]) -> String {
        var resultStr = String()
        var buffStr = valueBin
        
        buffStr = removeAllSpaces(str: buffStr)
        
        // from binary to octal or hex
        // divide by part
        let intParts = Int(valueBin.count / partition)
        // process each part
        // part is 3 or 4 digits
        for _ in 0..<intParts {
            var partCounter = 0
            var buffPart = String()
            // get first 3 chars
            while partCounter < partition {
                buffPart.append(buffStr.first!)
                // delete first char
                buffStr.removeFirst()
                
                partCounter += 1
            }
            // convert these part into Octal or Hexadeicaml by using table
            for (key, value) in table {
                if buffPart == key {
                    // append index from table
                    resultStr.append(value)
                    break
                }
            }
        }
        
        return resultStr
    }
    
    // remove all spaces
    func removeAllSpaces(str: String) -> String {
        var buffStr = ""
        str.forEach { (char) in
            // if char != space then ok
            if char != " " {
                buffStr.append(char)
            }
        }
        return buffStr
    }
}
