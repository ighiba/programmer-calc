//
//  Octal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

extension MainConverter {
    // =====
    // Octal
    // =====
    
    // Convert form oct or hex with table helper
    // Convert to oct or hex with table helper
    func convertOctHexTable(str: String, system: ConversionModel.ConversionSystemsEnum, toBinary: Bool) -> String {
        // remove all spaces
        var buffStr = removeAllSpaces(str: str)
        var buffResultStr = String()
        
        let partition: Int
        
        // octal or hex table
        // from 0 to 7 or from 0 to 16
        var table = ["":""]
        
        if system == .hex {
            // partititon set to 4
            partition = 4
            // hex table
            table = [   "0000":"0",
                        "0001":"1",
                        "0010":"2",
                        "0011":"3",
                        "0100":"4",
                        "0101":"5",
                        "0110":"6",
                        "0111":"7",
                        "1000":"8",
                        "1001":"9",
                        "1010":"A",
                        "1011":"B",
                        "1100":"C",
                        "1101":"D",
                        "1110":"E",
                        "1111":"F",]
            
        } else {
            // partittion set to 3
            partition = 3
            // octal table
            table = [   "000":"0",
                        "001":"1",
                        "010":"2",
                        "011":"3",
                        "100":"4",
                        "101":"5",
                        "110":"6",
                        "111":"7",]
        }
        
        if toBinary {
            // from octal or hex to binary
            // process each number and form parts
            buffStr.forEach { (num) in
                if num != "." {
                    for (key, value) in table {
                        if "\(num)" == value {
                            // append balue from table
                            buffResultStr.append("\(key)")
                            break
                        }
                    }
                } else {
                    // append .
                    buffResultStr.append(num)
                }
            }
        } else {
            // from binary to octal or hex
            // divide by part
            let intParts = Int(buffStr.count / partition)
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
                        buffResultStr.append(value)
                        break
                    }
                }
            }
        }
        return buffResultStr
    }
    
    // OCT -> BIN
    func convertOctToBin( octNumStr: String) -> String {
        let str = convertOctHexTable(str: octNumStr, system: .oct, toBinary: true)
        
        return divideStr(str: str, by: 3)
    }
    
    // TODO: Refactor to table
    // BIN -> OCT/HEX
    func convertBinToOctHex( binNumStr: String, targetSystem: ConversionModel.ConversionSystemsEnum) -> String {
        var resultStr: String
        
        // if zero
        guard binNumStr != "0" else {
            return "0"
        }
        
        // set partition
        let partition: Int = {
            if targetSystem == .hex {
                return 4
            } else {
                return 3
            }
        }()
     
        // Dividing to int and fract parts
        let buffDividedStr = divideToDoubleInt(str: binNumStr)
        var binIntStrBuff = buffDividedStr.0
        
        var resultIntStr = String()
        var resultFractStr = String()
        
       
        guard binIntStrBuff != nil else {
            return "Error"
        }
        
        // delete zeros from parts by 4 and filling up by 3
        binIntStrBuff = fillUpParts(by: partition, binIntStrBuff!)
        
        // First: converting int part
        // dont count if zero
        if binIntStrBuff == "0" {
            resultIntStr = "0"
        } else {
            // First: converting int part
            resultIntStr = convertOctHexTable(str: binIntStrBuff!, system: targetSystem, toBinary: false)
        }
        
        
        
        // Second: converting fract part
        if let binFractStrBuff = buffDividedStr.1 {
            // Check for zero in fract
            guard binFractStrBuff != "0" else {
                return "\(resultIntStr).\(binFractStrBuff)"
            }
            
            var strBuff = binFractStrBuff
            // reverse for conversion
            strBuff = String(strBuff.reversed())
            // delete zeros from parts by 4 and filling up by 3
            strBuff = fillUpParts(by: partition, strBuff)
            // reverse back
            strBuff = String(strBuff.reversed())
            // add zeros to end
            resultFractStr = convertOctHexTable(str: strBuff, system: targetSystem, toBinary: false)
            
            // if low precise
            // TODO: Make advice to slider with number of digits
            if resultFractStr == "" {
                resultFractStr = "0"
            }
            
            resultStr = "\(resultIntStr).\(resultFractStr)"
            return resultStr
            
        } else {
            // return int
            resultStr = "\(resultIntStr)"
            return resultStr
        }
    }
    
    // ===========
    // Hexadecimal
    // ===========
    
    // HEX -> BIN
    func convertHexToBin(hexNumStr: String) -> String {
        let str = convertOctHexTable(str: hexNumStr, system: .hex, toBinary: true)
        
        return divideStr(str: str, by: 4)
    }
}
