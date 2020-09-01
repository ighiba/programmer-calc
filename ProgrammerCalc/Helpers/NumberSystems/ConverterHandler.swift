//
//  MainConverter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

 class ConverterHandler {
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Main function for conversion values
    public func convertValue(value valueStr: String, from mainSystem: String, to converterSystem: String) -> String? {
        
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
        var partition: Int = 4
        
        switch anySystem {
        case "Binary":
            // if already binary
            binary = Binary(stringLiteral: anyStr)
            break
        case "Octal":
            // convert oct to binary
            partition = 3
            
            let oct = Octal(stringLiteral: anyStr)
            binary = Binary(oct)
            break
        case "Decimal":
            // convert dec to binary
            partition = 4
            let dec = Decimal(string: anyStr)!
            binary = Binary(dec)
            break
        case "Hexadecimal":
            // convert hex to binary
            partition = 4
            let hex = Hexadecimal(stringLiteral: anyStr)
            binary = Binary(hex)
            break
        default:
            // do nothing
            // TODO: Error handling
            binary = "0"
            break
        }
        
        // divide binary by parts
        binary = binary.divideBinary(by: partition)


        return binary
    }
    
    // Converter from binary to any system
    fileprivate func convertBinaryToAny( binary: Binary, targetSystem: String) -> String {
        let binaryStr = binary.value
        var targetStr: String
        
        switch targetSystem {
        case "Binary":
            // convert binary to binary
            return binaryStr
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
    
    // Convert value to one's complement
    public func toOnesComplement( valueStr: String, mainSystem: String) -> String {
        var resultStr = String()
        let binary = Binary()
        var signedBit = String()
        
        // convert to Binary
        binary.value = convertValue(value: valueStr, from: mainSystem, to: "Binary") ?? "0"
        // delete signed bit if exist
        binary.ifProcessSigned {
            signedBit = String(binary.value.first!)
            binary.value.removeFirst()
        }
        // invert binary
        binary.invert()
        // return signed bit if exists
        binary.value = signedBit + binary.value
        // convert to mainSystem
        resultStr = convertValue(value: binary.value, from: "Binary", to: mainSystem) ?? "0"
    
        return resultStr
    }
    
    // Convert value to two's complement
    public func toTwosComplement( valueStr: String, mainSystem: String) -> String {
        var resultStr = String()
        let binary = Binary()
        var signedBit = String()
        
        // convert to Binary
        binary.value = convertValue(value: valueStr, from: mainSystem, to: "Binary") ?? "0"
        // convert to 1's complement
        binary.value = toOnesComplement(valueStr: binary.value, mainSystem: "Binary")
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
        
        // convert to mainSystem
        resultStr = convertValue(value: binary.value, from: "Binary", to: mainSystem) ?? "0"
    
        return resultStr
    }
    
    
    // Shift left 1 bit
    public func shiftLeft( valueStr: String, mainSystem: String) -> String {
        // convert to Decimal
        let decimalStr = convertValue(value: valueStr, from: mainSystem, to: "Decimal") ?? "0"
        // TODO: Error handling
        let decimal = Int(decimalStr) ?? 0
        
        // shift left by 1 bit
        var resultStr = String(decimal << 1)
        
        // convert to mainSystem
        resultStr = convertValue(value: resultStr, from: "Decimal", to: mainSystem) ?? "0"
    
        return resultStr
    }
}
