//
//  MainConverter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

 class MainConverter {
    
    // =======
    // Methods
    // =======
    
    // Main function for conversion values
    func convertValue(value valueStr: String, from mainSystem: String, to converterSystem: String) -> String? {
        // exit if systems are equal
        guard mainSystem != converterSystem else {
            return valueStr
        }
        
        // =======================================
        // First step: convert any value to binary
        // =======================================
        let binaryStr = convertAnyToBinary(anyStr: valueStr, anySystem: mainSystem)
        
        // ==================================================
        // Second step: convert binary value to needed system
        // ==================================================
        
        let resultStr = convertBinaryToAny(binaryStr: binaryStr, targetSystem: converterSystem)
        
        return resultStr
    }
    
    // Converter from any to binary system
    fileprivate func convertAnyToBinary( anyStr: String, anySystem: String) -> String {
        var binaryStr: String
        
            switch anySystem {
            case "Binary":
                // if already binary
                binaryStr = anyStr
                break
            case "Octal":
                // convert oct to binary
                let oct = Octal(stringLiteral: anyStr)
                binaryStr = Binary(oct).value
                break
            case "Decimal":
                // convert dec to binary
                //binaryStr = self.convertDecToBinary(decNumStr: anyStr)
                binaryStr = Binary(Decimal(string: anyStr)!).value
                break
            case "Hexadecimal":
                // convert hex to binary
                let hex = Hexadecimal(stringLiteral: anyStr)
                binaryStr = Binary(hex).value
                break
            default:
                // do nothing
                // TODO: Error handling
                binaryStr = "0"
                break
            }

        return binaryStr
    }
    
    // Converter from binary to any system
    fileprivate func convertBinaryToAny( binaryStr: String, targetSystem: String) -> String {
        var targetStr: String
        
            switch targetSystem {
            case "Binary":
                // convert binary to binary
                targetStr = binaryStr
                break
            case "Octal":
                // convert binary to oct
                let bin = Binary(stringLiteral: binaryStr)
                targetStr = Octal(bin).value
                //targetStr = self.convertBinToOctHex(binNumStr: binaryStr, targetSystem: .oct)
                break
            case "Decimal":
                // convert binary to dec
                //targetStr = "0"
                //targetStr = self.convertBinToDec(binNumStr: binaryStr)
                let bin = Binary(stringLiteral: binaryStr)
                targetStr = "\(Decimal(bin))"
                break
            case "Hexadecimal":
                // convert binary to hex
                //targetStr = self.convertBinToOctHex(binNumStr: binaryStr, targetSystem: .hex)
                let bin = Binary(stringLiteral: binaryStr)
                targetStr = Hexadecimal(bin).value
                break
            default:
                // do nothing
                // TODO: Error handling
                targetStr = "err"
                break
            }
        
        return targetStr
    }
}
