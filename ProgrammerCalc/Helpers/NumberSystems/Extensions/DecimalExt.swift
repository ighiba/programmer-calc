//
//  DecimalExt.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

extension Decimal {
    
    
    init(_ valueBin: Binary) {
        self.init()
        self = valueBin.convertBinaryToDec()
    }
    
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Handle converting values NumberSystem
    
    // DEC -> BIN
    func convertDecToBinary() -> Binary {
        var decNumStr: String
        var binary = Binary()
        
        let isDecSigned: Bool = {
            if self < 0 {
                return true
            } else {
                return false
            }
        }()

        // if number is signed
        // TODO: Signed handling
        
        if isDecSigned {
            decNumStr = String("\(self * -1)")
        } else {
            decNumStr = String("\(self)")
        }
              

        if let decNumInt: Int = Int(decNumStr) {
            let str = binary.convertIntToBinary(decNumInt)
            binary = Binary(stringLiteral: str)
        } else {
            // TODO   Error handling
            let splittedDoubleStr = binary.divideIntFract(value: decNumStr)
            let str = binary.convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            binary = Binary(stringLiteral: str)

        }
        
        if let data = SavedData.calcState?.processSigned {
            if data {
                let splittedBinaryStr = binary.divideIntFract(value: binary.value)
                
                if let intPart = splittedBinaryStr.0 {
                    binary.value = intPart
                    // remove zeros
                    binary.value = binary.removeZerosBefore(str: binary.value)
                    // set signed state to binary
                    binary.isSigned = isDecSigned
                    // fill up to signed binary style
                    binary.fillUpSignedToNeededCount()
                }
                
                // add fract part if exists
                if let fractPart = splittedBinaryStr.1 {
                    binary.value = "\(binary.value).\(fractPart)"
                }

            } 
        }
        
        return binary
    }
}
