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
    
    // Storages
    //private let calcStateStorage = CalcStateStorage()
    //private let wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    
    // ======================
    // MARK: - Initialization
    // ======================
    
    required init(stringLiteral: String) {
        self.value = stringLiteral
        self.decimalValue = Decimal(string: stringLiteral) ?? Decimal(0)
        updateIsSignedState()
    }

    init(_ valueDec: Decimal) {
        self.decimalValue = valueDec
        self.value = "\(self.decimalValue)"
        updateIsSignedState()
    }
    
    init(_ valueInt: Int) {
        self.decimalValue = Decimal(valueInt)
        self.value = "\(self.decimalValue)"
        updateIsSignedState()
    }
    
    init(_ valueBin: Binary) {
        self.decimalValue = valueBin.convertBinaryToDec()
        self.value = "\(self.decimalValue)"
        updateIsSignedState()
    }
    
    init(_ valueDec: DecimalSystem) {
        self.decimalValue = valueDec.decimalValue
        self.value = valueDec.value
        self.isSigned = valueDec.isSigned
    }
    
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Handle converting values NumberSystem
    
    // DEC -> BIN
    func convertDecToBinary() -> Binary? {
        var decNumStr: String
        var binary = Binary()
        
        updateIsSignedState()

        // if number is signed
        // remove minus for converting
        if isSigned {
            decimalValue *= -1
        }
        
        decNumStr = "\(decimalValue)"

        if decNumStr.contains(".") {
            // Process float numbers
            let splittedDoubleStr = binary.divideIntFract(value: decNumStr)
            let str = binary.convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            binary = Binary(stringLiteral: str)
        } else {
            let str = binary.convertDecToBinary(decimalValue)
            binary = Binary(stringLiteral: str)
        }
        // return sign to decimal
        if isSigned {
            decimalValue *= -1
        }
        
        // process value
            let splittedBinaryStr = binary.divideIntFract(value: binary.value)
            
            // process int part of binary
            if let intPart = splittedBinaryStr.0 {
                binary.value = intPart
                // remove zeros
                binary.value = binary.removeZerosBefore(str: binary.value)
                // set signed state to binary
                binary.isSigned = self.isSigned
                // fill up to 63 bits
                binary.fillUpToMaxBitsCount()
                // isSigned == true -> 1 else -> 0

                binary.value = "0" + binary.value
                if self.isSigned {
                    binary.twosComplement()
                }
            }
            
            // add fract part if exists
            if let fractPart = splittedBinaryStr.1 {
                // invert fract part if isSigned
                if isSigned {
                    let invertedFractPart = fractPart.swap(first: "1", second: "0")
                    binary.value = "\(binary.value).\(invertedFractPart)"
                } else {
                    binary.value = "\(binary.value).\(fractPart)"
                }
            }

        
        return binary
    }
    
    private func updateIsSignedState() {
        if decimalValue < 0 {
            isSigned = true
        } else {
            isSigned = false
        }
    }
    
    // Change raw decimal value and update sign state
    func setNewDecimal(with decimalValue: Decimal) {
        self.decimalValue = decimalValue
        self.value = "\(decimalValue)"
        updateIsSignedState()
    }
    
    func removeFractPart() -> Decimal {
        let dec = DecimalSystem(self)
        var decIntPart = dec.decimalValue
        var decIntPartCopy = decIntPart
        // round decimal
        if dec.decimalValue > 0 {
            NSDecimalRound(&decIntPart, &decIntPartCopy, 0, .down)
        } else {
            NSDecimalRound(&decIntPart, &decIntPartCopy, 0, .up)
        }
        
        // update self value
        setNewDecimal(with: decIntPart)
        
        // return fract part of decimal
        return decIntPartCopy - decIntPart
    }
}
