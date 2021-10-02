//
//  DecimalSystem.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 30.09.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class DecimalSystem: NumberSystemProtocol {
    
    // ==================
    // MARK: - Properties
    // ==================
    
    var decimalValue: Decimal
    
    var value: String
    var isSigned: Bool = false
    
    // CalcState storage
    private var calcStateStorage = CalcStateStorage()
    
    // ======================
    // MARK: - Initialization
    // ======================
    
    required init(stringLiteral: String) {
        self.value = stringLiteral
        self.decimalValue = Decimal(string: stringLiteral) ?? Decimal(0)
    }

    init(_ valueDec: Decimal) {
        self.decimalValue = valueDec
        self.value = "\(self.decimalValue)"
    }
    
    init(_ valueInt: Int) {
        self.decimalValue = Decimal(valueInt)
        self.value = "\(self.decimalValue)"
    }
    
    init(_ valueBin: Binary) {
        self.decimalValue = valueBin.convertBinaryToDec()
        self.value = "\(self.decimalValue)"
    }
    
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Handle converting values NumberSystem
    
    // DEC -> BIN
    func convertDecToBinary() -> Binary {
        var decNumStr: String
        var binary = Binary()
        
        if decimalValue < 0 {
            isSigned = true
        } else {
            isSigned = false
        }

        // if number is signed
        // TODO: Signed handling
        
        if isSigned {
            decNumStr = String("\(decimalValue * -1)")
        } else {
            decNumStr = String("\(decimalValue)")
        }

        if let decNumInt: Int = Int(decNumStr) {
            let str = binary.convertIntToBinary(decNumInt)
            binary = Binary(stringLiteral: str)
        } else if decNumStr.contains("."){
            // TODO   Error handling
            let splittedDoubleStr = binary.divideIntFract(value: decNumStr)
            let str = binary.convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            binary = Binary(stringLiteral: str)
        } else {
            
            //
            if !calcStateStorage.isProcessSigned() && decNumStr == "9223372036854775808" {
                binary = Binary(stringLiteral: "1000000000000000000000000000000000000000000000000000000000000000")
            } else {
                print("error oveflow")
            }
        }
        
        // process signed from UserDefaults
        if calcStateStorage.isProcessSigned() {
            let splittedBinaryStr = binary.divideIntFract(value: binary.value)
            
            if let intPart = splittedBinaryStr.0 {
                binary.value = intPart
                // remove zeros
                binary.value = binary.removeZerosBefore(str: binary.value)
                // set signed state to binary
                binary.isSigned = self.isSigned
                // fill up to signed binary style
                binary.fillUpSignedToNeededCount()
                // convert to 2's complenment state if value is signed
                if binary.isSigned {
                    binary.twosComplement()
                }
            }
            
            // add fract part if exists
            if let fractPart = splittedBinaryStr.1 {
                binary.value = "\(binary.value).\(fractPart)"
            }
        }
        
        return binary
    }
}

// Converting binary string in decimal number
extension Decimal {
    init(_ str: String, radix: Int) {
        self.init()
        var decimal = Decimal()
        var multiplier = str.count - 1
        for bit in str {
            decimal += Decimal(string: String(bit))! * Decimal(pow(Double(radix), Double(multiplier)))
            multiplier -= 1
        }
        self = decimal
    }
}
