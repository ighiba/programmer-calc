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
    public func convertValue(value valueStr: String, from mainSystem: ConversionSystemsEnum, to converterSystem: ConversionSystemsEnum) -> String? {
        
        // =======================================
        // First step: convert any value to binary
        // =======================================
        let binary = convertAnyToBinary(anyStr: valueStr, anySystem: mainSystem)
        
        // ==================================================
        // Second step: convert binary value to needed system
        // ==================================================
        
        let resultStr = convertBinaryToAny(binary: binary, targetSystem: converterSystem).value
        
        return resultStr
    }
    
    // Converter from any to binary system
    fileprivate func convertAnyToBinary( anyStr: String, anySystem: ConversionSystemsEnum) -> Binary {
        var binary: Binary
        var partition: Int = 4
        
        switch anySystem {
        case .bin:
            // if already binary
            binary = Binary(stringLiteral: anyStr)
        case .oct:
            // convert oct to binary
            partition = 3
            let oct = Octal(stringLiteral: anyStr)
            binary = Binary(oct)
        case .dec:
            // convert dec to binary
            partition = 4
            let dec = DecimalSystem(stringLiteral: anyStr)
            binary = Binary(dec)
        case .hex:
            // convert hex to binary
            partition = 4
            let hex = Hexadecimal(stringLiteral: anyStr)
            binary = Binary(hex)
        }
        
        // divide binary by parts
        binary = binary.divideBinary(by: partition)

        return binary
    }
    
    // Converter from binary to any system
    fileprivate func convertBinaryToAny( binary: Binary, targetSystem: ConversionSystemsEnum) -> NumberSystemProtocol {

        switch targetSystem {
        case .bin:
            // convert binary to binary
            return binary
        case .oct:
            // convert binary to oct
            return Octal(binary)
        case .dec:
            // convert binary to dec
            return DecimalSystem(binary)
        case .hex:
            // convert binary to hex
            return Hexadecimal(binary)
        }
    }
    
    // Convert value to one's complement
    public func toOnesComplement( valueStr: String, mainSystem: ConversionSystemsEnum) -> String {
        var resultStr = String()
        let binary = Binary()
        
        // convert to Binary
        binary.value = convertValue(value: valueStr, from: mainSystem, to: .bin) ?? "0"
        
        // convert binary to one's complement
        binary.onesComplement()

        // convert to binary input system (mainSystem)
        resultStr = convertValue(value: binary.value, from: .bin, to: mainSystem) ?? "0"
    
        return resultStr
    }
    
    // Convert value to two's complement
    public func toTwosComplement( valueStr: String, mainSystem: ConversionSystemsEnum) -> String {
        var resultStr = String()
        let binary = Binary()
        
        // convert to Binary
        binary.value = convertValue(value: valueStr, from: mainSystem, to: .bin) ?? "0"
        
        // convert binary to 2's complement
        binary.twosComplement()
        
        // convert to binary input system (mainSystem)
        resultStr = convertValue(value: binary.value, from: .bin, to: mainSystem) ?? "0"
    
        return resultStr
    }
    
    
    // Shift to needed bit count
    public func shiftBits( value valueStr: String, mainSystem: ConversionSystemsEnum, shiftOperation: (Int,Int)->Int, shiftCount: Int ) -> String {
        // convert to Decimal
        let decimalStr = convertValue(value: valueStr, from: mainSystem, to: .dec) ?? "0"
        // TODO: Error handling
        let decimal = Int(decimalStr) ?? 0
        
        // shift left by 1 bit
        var resultStr = String(shiftOperation(decimal,shiftCount))
        
        // convert to mainSystem
        resultStr = convertValue(value: resultStr, from: .dec, to: mainSystem) ?? "0"
        return resultStr
    }
}
