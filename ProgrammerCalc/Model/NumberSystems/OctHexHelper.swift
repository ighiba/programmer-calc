//
//  OctHexHelper.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 30.09.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

class OctHexHelper {
    
    // CalcState storage
    //private var calcStateStorage = CalcStateStorage()
    
    // =========================================
    // MARK: - Octal / Hexadecimal Table Methods
    // =========================================
    
    // Parsing tables dictionary hex or oct for converting to bin
    func tableOctHexToBin( valueOctHex: String, table: [String : String]) -> String {
        let resultBin = Binary()
        resultBin.value = ""
        
        // from hex or oct to binary
        // process each number and form parts
        valueOctHex.forEach { (num) in
            if num != "." {
                for (key, value) in table {
                    if "\(num)" == value {
                        // append balue from table
                        resultBin.value.append("\(key)")
                        break
                    }
                }
            } else {
                // append .
                resultBin.value.append(num)
            }
        }
       
        // remove zeros
        resultBin.value = resultBin.removeZerosBefore(str: resultBin.value)
        // add zero if all zeros deleted
        if resultBin.value.first == "." {
            resultBin.value = "0" + resultBin.value
        }
        // add zeros before to 64 bits
        resultBin.fillUpToMaxBitsCount()
        
        return resultBin.value
    }
    
    // Parsing tables dictionary bin for converting to hex or oct
    func tableOctHexFromBin( valueBin: String, partition: Int, table: [String : String]) -> String {
        var resultStr = String()
        var buffStr = valueBin
        
        // remove spaces
        buffStr = buffStr.removeAllSpaces()
        
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
    
}
