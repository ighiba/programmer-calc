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
    public func convertValue(value: NumberSystemProtocol, from mainSystem: ConversionSystemsEnum, to converterSystem: ConversionSystemsEnum) -> NumberSystemProtocol? {
        // if manSystem == converterSystem, then return imput value
        if mainSystem == converterSystem {
            return value
        }
        
        // =======================================
        // First step: convert any value to binary
        // =======================================
        let binary = convertAnyToBinary(value: value, anySystem: mainSystem)
        
        // Check if not nil after converting to binary
        guard binary != nil else { return nil }
        
        // ==================================================
        // Second step: convert binary value to needed system
        // ==================================================
        
        let result = convertBinaryToAny(binary: binary!, targetSystem: converterSystem)
        
        return result
    }
    
    // Converter from any to binary system
    fileprivate func convertAnyToBinary( value: NumberSystemProtocol, anySystem: ConversionSystemsEnum) -> Binary? {
        var binary: Binary?
        var partition: Int = 4
        
        switch anySystem {
        case .bin:
            // if already binary
            if let bin = value as? Binary {
                binary = Binary(bin)
            }
        case .oct:
            // convert oct to binary
            partition = 3
            let oct: Octal = value as! Octal
            binary = Binary(oct)
        case .dec:
            // convert dec to binary
            partition = 4
            let dec = value as! DecimalSystem
            if let bin = Binary(dec) {
                binary = bin
            }
        case .hex:
            // convert hex to binary
            partition = 4
            let hex = value as! Hexadecimal
            binary = Binary(hex)
        }
        
        // check if binary is nil
        guard binary != nil else { return nil }
        
        // divide binary by parts
        binary = binary!.divideBinary(by: partition)

        return binary
    }
    
    // Converter from binary to any system
    fileprivate func convertBinaryToAny( binary: Binary, targetSystem: ConversionSystemsEnum) -> NumberSystemProtocol {

        switch targetSystem {
        case .bin:
            // convert binary to binary
            return Binary(binary)
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
    public func toOnesComplement( value: NumberSystemProtocol, mainSystem: ConversionSystemsEnum) -> NumberSystemProtocol {
        var binary = Binary()
        
        // convert to Binary
        binary = convertValue(value: value, from: mainSystem, to: .bin) as! Binary
        
        // convert binary to one's complement
        binary.onesComplement()

        // convert to binary input system (mainSystem)
        return convertValue(value: binary, from: .bin, to: mainSystem)!
    
    }
    
    // Convert value to two's complement
    public func toTwosComplement( value: NumberSystemProtocol, mainSystem: ConversionSystemsEnum) -> NumberSystemProtocol {
        var binary = Binary()
        
        // convert to Binary
        binary = convertValue(value: value, from: mainSystem, to: .bin) as! Binary
        
        // convert binary to 2's complement
        binary.twosComplement()
        
        // convert to binary input system (mainSystem)

        return convertValue(value: binary, from: .bin, to: mainSystem)!
    }
    
}
