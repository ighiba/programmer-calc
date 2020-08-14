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
    
    
    // =======
    // Methods
    // =======
    
    // Handle converting values NumberSystem
    
    // DEC -> BIN
    func convertDecToBinary() -> Binary {
        let decNumStr = String("\(self)")
        var _: Bool = false
        var binaryStr = Binary()

        // if number is signed
        // TODO: Signed handling

        if let decNumInt: Int = Int(decNumStr) {
            let str = binaryStr.convertIntToBinary(decNumInt)
            binaryStr = Binary(stringLiteral: str)
        } else {
            // TODO   Error handling
            let splittedDoubleStr = binaryStr.divideIntFract(value: decNumStr)
            let str = binaryStr.convertDoubleToBinaryStr(numberStr: splittedDoubleStr)
            binaryStr = Binary(stringLiteral: str)

        }
        return binaryStr
    }
}
