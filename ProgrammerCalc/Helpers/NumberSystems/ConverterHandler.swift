//
//  MainConverter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

 class ConverterHandler {
    
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
        let binary = convertAnyToBinary(anyStr: valueStr, anySystem: mainSystem)
        
        // ==================================================
        // Second step: convert binary value to needed system
        // ==================================================
        
        let resultStr = convertBinaryToAny(binary: binary, targetSystem: converterSystem)
        
        return resultStr
    }
    
    // Converter from any to binary system
    fileprivate func convertAnyToBinary( anyStr: String, anySystem: String) -> Binary {
        var binary: Binary
        
            switch anySystem {
            case "Binary":
                // if already binary
                binary = Binary(stringLiteral: anyStr)
                break
            case "Octal":
                // convert oct to binary
                let oct = Octal(stringLiteral: anyStr)
                binary = Binary(oct)
                break
            case "Decimal":
                // convert dec to binary
                let dec = Decimal(string: anyStr)!
                binary = Binary(dec)
                break
            case "Hexadecimal":
                // convert hex to binary
                let hex = Hexadecimal(stringLiteral: anyStr)
                binary = Binary(hex)
                break
            default:
                // do nothing
                // TODO: Error handling
                binary = "0"
                break
            }

        return binary
    }
    
    // Converter from binary to any system
    fileprivate func convertBinaryToAny( binary: Binary, targetSystem: String) -> String {
        let binaryStr = binary.value
        var targetStr: String
        
            switch targetSystem {
            case "Binary":
                // convert binary to binary
                targetStr = binaryStr
                break
            case "Octal":
                // convert binary to oct
                targetStr = Octal(binary).value
                break
            case "Decimal":
                // convert binary to dec
                targetStr = "\(Decimal(binary))"
                break
            case "Hexadecimal":
                // convert binary to hex
                targetStr = Hexadecimal(binary).value
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
