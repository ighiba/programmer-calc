//
//  Converter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

 class Converter {
    
    // Storages
    private let calcStateStorage = CalcStateStorage()
    private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    private let conversionStorage: ConversionStorageProtocol = ConversionStorage()
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Main function for conversion values
    public func convertValue(value: NumberSystemProtocol,
                             from mainSystem: ConversionSystemsEnum,
                             to converterSystem: ConversionSystemsEnum,
                             format processToFormat: Bool) -> NumberSystemProtocol? {
        
        // if manSystem == converterSystem, then return imput value
        // except binary (for processing it to normal format)
        if mainSystem == converterSystem && mainSystem != .bin {
            return value
        }
        
        // =======================================
        // First step: convert any value to binary
        // =======================================
        var binary = convertAnyToBinary(value: value, anySystem: mainSystem)
        
        // Check if not nil after converting to binary
        guard binary != nil else { return nil }
        
        if processToFormat {
            // Process binary to settings format
            binary = processBinaryToFormat(binary!)
        }

        // ==================================================
        // Second step: convert binary value to needed system
        // ==================================================
        
        let result = convertBinaryToAny(binary: binary!, targetSystem: converterSystem)
        
        return result
    }
    
    // Converter from any to binary system
    fileprivate func convertAnyToBinary( value: NumberSystemProtocol, anySystem: ConversionSystemsEnum) -> Binary? {
        var binary: Binary?
        
        switch anySystem {
        case .bin:
            // if already binary
            if let bin = value as? Binary {
                binary = Binary(bin)
            }
        case .oct:
            // convert oct to binary
            let oct: Octal = value as! Octal
            binary = Binary(oct)
        case .dec:
            // convert dec to binary
            let dec = value as! DecimalSystem
            if let bin = Binary(dec) {
                binary = bin
            }
        case .hex:
            // convert hex to binary
            let hex = value as! Hexadecimal
            binary = Binary(hex)
        }
        
        // check if binary is nil
        guard binary != nil else { return nil }

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
            let dec = DecimalSystem(binary)
            if !calcStateStorage.isProcessSigned() {
                if dec.decimalValue < 0 {
                    dec.setNewDecimal(with: dec.decimalValue * -1)
                }
            }
            return dec
        case .hex:
            // convert binary to hex
            return Hexadecimal(binary)
        }
    }
    
    // Convert value to one's complement
    public func toOnesComplement( value: NumberSystemProtocol, mainSystem: ConversionSystemsEnum) -> NumberSystemProtocol {
        var binary = Binary()
        
        // convert to Binary
        binary = convertValue(value: value, from: mainSystem, to: .bin, format: true) as! Binary
        
        // convert binary to one's complement
        binary.onesComplement()
        
        if calcStateStorage.isProcessSigned() {
            binary.updateSignedState()
        }

        // convert to binary input system (mainSystem)
        let resultBin = convertValue(value: binary, from: .bin, to: mainSystem, format: true)!
        
        return resultBin
    
    }
    
    // Convert value to two's complement
    public func toTwosComplement( value: NumberSystemProtocol, mainSystem: ConversionSystemsEnum) -> NumberSystemProtocol {
        var binary = Binary()
        
        // convert to Binary
        binary = convertValue(value: value, from: mainSystem, to: .bin, format: true) as! Binary
        
        // convert binary to 2's complement
        binary.twosComplement()
        
        // convert to binary input system (mainSystem)
        return convertValue(value: binary, from: .bin, to: mainSystem, format: true)!
    }
    
    // Process binary with settings from User Defaults
    public func processBinaryToFormat(_ binary: Binary) -> Binary {
        let resultBin = Binary()
        // get word size from storage
        let wordSizeValue = wordSizeStorage.getWordSizeValue()
        
        // remove spaces if exists
        binary.value = binary.value.removeAllSpaces()
        
        // split binary
        let splittedBinary = binary.divideIntFract(value: binary.value)
        
        // process int part
        if let intPart = splittedBinary.0 {
            var buffIntPart = binary.removeZerosBefore(str: intPart)
            // fill or delete bits
            if buffIntPart.count < wordSizeValue {
                // add bits
                while buffIntPart.count < wordSizeValue {
                    buffIntPart = "0" + buffIntPart
                }
            } else if buffIntPart.count > wordSizeValue {
                // delete bits down to wordSizeValue
                while buffIntPart.count > wordSizeValue {
                    buffIntPart.removeFirst(1)
                }
            } else if buffIntPart.count == wordSizeValue {
                
            }
            
            resultBin.value = buffIntPart
            
            // update signed value
            if calcStateStorage.isProcessSigned() {
                resultBin.updateSignedState()
            }
        }
        
        // process fract part
        if let fractPart = splittedBinary.1 {
            let numAfterPoint = conversionStorage.safeGetData().numbersAfterPoint
            var buffFractPart = fractPart.removeTrailing(characters: ["0"])
            
            if fractPart != "" {
                // fill or delete bits
                if buffFractPart.count < numAfterPoint {
                    // add bits
                    //print("add bits")
                    while buffFractPart.count < numAfterPoint {
                        buffFractPart.append("0")
                    }
                } else if buffFractPart.count > numAfterPoint {
                    // delete bits down to numAfterPoint
                    while buffFractPart.count > numAfterPoint {
                        buffFractPart.removeLast(1)
                    }
                } else if buffFractPart.count == numAfterPoint {
                    // do nothing all ok
                }
            }
            
            resultBin.value.append(".")
            resultBin.value.append(buffFractPart)
        }
        
        if !calcStateStorage.isProcessSigned() {
            resultBin.isSigned = false
        }
        
        return resultBin
    }
    
    func processDecFloatStrToFormat(decStr: String, lastDotIfExists: String) -> String {
        var lastSymbolsIfExists = lastDotIfExists
        
        // Process fact part if exists and last digit is 0
        if decStr.last == "0" && decStr.contains(".") {
            // count how much zeros in back
            let fractPart = decStr.getPartAfter(divider: ".")
            
            let buffFractPart = String(fractPart.reversed())
            var buffStr = ""
            for digit in buffFractPart {
                if digit == "0" {
                    buffStr.append(digit)
                } else {
                    break
                }
            }
            // check if fract part not 0, 00 ,000 etc.
            if Int(fractPart) != 0 {
                lastSymbolsIfExists = buffStr
            }
        }
        
        // get dec value
        let dec = DecimalSystem(stringLiteral: decStr)
        // get int part of decimal
        var decIntPart = dec.decimalValue
        var decIntPartCopy = decIntPart
        // round decimal
        if dec.decimalValue > 0 {
            NSDecimalRound(&decIntPart, &decIntPartCopy, 0, .down)
        } else {
            NSDecimalRound(&decIntPart, &decIntPartCopy, 0, .up)
        }
        // get fract part of decimal
        let decFractPart = decIntPartCopy - decIntPart
        dec.setNewDecimal(with: decIntPart)
        // convert to binary
        let bin = convertValue(value: dec, from: .dec, to: .bin, format: true) as! Binary
        // convert processed bin back in dec
        let updatedDec = convertValue(value: bin, from: .bin, to: .dec, format: true)  as! DecimalSystem
        // restore new decimal with fract part
        dec.setNewDecimal(with: updatedDec.decimalValue + decFractPart)
        
        // set updated main label value + last symbols if exists
        return dec.value + lastSymbolsIfExists
    }
    
}
