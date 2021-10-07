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
    let max = Decimal(string: "18446744073709551615")!
    let maxSigned = Decimal(string: "9223372036854775807")!
    let minSigned = Decimal(string: "-9223372036854775808")!
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
        // TODO: Signed handling
        
        if isSigned {
            decimalValue *= -1
        }
        
        decNumStr = "\(decimalValue)"

        if decNumStr.contains(".") {
            // Process float numbers
            // TODO   Error handling
            let splittedDoubleStr = binary.divideIntFract(value: decNumStr)
            let str = binary.convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            binary = Binary(stringLiteral: str)
        } else {
            // TODO   Error handling
            //print("handling overflow DEC to BIN - signed")
            let str = binary.convertDecToBinary(decimalValue)
            binary = Binary(stringLiteral: str)
        }
        // return sign to decimal
        if isSigned {
            decimalValue *= -1
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
                // isSigned == true -> 1 else -> 0
                if binary.isSigned {
                    binary.value = "1" + binary.value
                } else {
                    binary.value = "0" + binary.value
                }
                
                // check if min signed
                var binaryTest = binary.value
                binaryTest.removeFirst(1)
                
                if binaryTest.first == "1" && binaryTest.replacingOccurrences(of: "0", with: "").count == 1 && binaryTest.count == wordSize_Global {
                    binary.value = binaryTest
                }
                
                // convert to 2's complenment state if value is signed
                if binary.isSigned {
                    binary.twosComplement()
                }
                
                if (self.decimalValue > self.maxSigned) || (self.decimalValue < self.minSigned) {
                    print("overflow when convert dec to bin - \(decimalValue)")
                    //return nil
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
    
    func setNewDecimal(with decimalValue: Decimal) {
        self.decimalValue = decimalValue
        self.value = "\(decimalValue)"
        updateIsSignedState()
    }
}
