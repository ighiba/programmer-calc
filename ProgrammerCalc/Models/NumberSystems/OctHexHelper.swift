//
//  OctHexHelper.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 30.09.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

class OctHexHelper {
    
    // MARK: - Octal / Hexadecimal Table Methods
    
    func tableOctHexToBin( valueOctHex: String, table: [String : String]) -> String {
        let resultBin = Binary()
        resultBin.value = ""
        
        valueOctHex.forEach { (num) in
            if num != "." {
                for (key, value) in table {
                    if "\(num)" == value {
                        resultBin.value.append("\(key)")
                        break
                    }
                }
            } else {
                resultBin.value.append(num)
            }
        }
       
        resultBin.value = resultBin.removeZerosBefore(str: resultBin.value)
        if resultBin.value.first == "." {
            resultBin.value = "0" + resultBin.value
        }
        resultBin.fillUpToMaxBitsCount()
        
        return resultBin.value
    }
    
    func tableOctHexFromBin( valueBin: String, partition: Int, table: [String : String]) -> String {
        var resultStr = String()
        var buffStr = valueBin
        buffStr = buffStr.removedAllSpaces()
        
        let intParts = Int(valueBin.count / partition)
        for _ in 0..<intParts {
            var partCounter = 0
            var buffPart = String()

            while partCounter < partition {
                buffPart.append(buffStr.first!)
                buffStr.removeFirst()
                
                partCounter += 1
            }
            for (key, value) in table {
                if buffPart == key {
                    resultStr.append(value)
                    break
                }
            }
        }
        
        return resultStr
    }
}
