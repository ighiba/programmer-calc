//
//  Hexadecimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class Hexadecimal: NumberSystem {

    // hex table for converting from binary to hex
    // from 0 to 16
    let table = [   "0000":"0",
                    "0001":"1",
                    "0010":"2",
                    "0011":"3",
                    "0100":"4",
                    "0101":"5",
                    "0110":"6",
                    "0111":"7",
                    "1000":"8",
                    "1001":"9",
                    "1010":"A",
                    "1011":"B",
                    "1100":"C",
                    "1101":"D",
                    "1110":"E",
                    "1111":"F",]
    
    required public init(stringLiteral value: String) {
        super.init(stringLiteral: value)
    }
    
    /// Creates an empty instance
    override init() {
        super.init()
    }
    
    /// Creates an instance initialized to the Binary value
    override init(_ valueBin: Binary) {
        super.init()
        let hexadecimal = valueBin.convertBinaryToHex(hexTable: table)
        self.value = hexadecimal.value
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // HEX -> BIN
    // Convert form hex to binary with table helper
    func convertHexToBinary() -> Binary {
        let hexadecimal = self.value
        let binary = Binary()
        
        //let partition: Int = 4
        
        // TODO: Remove spaces

        // from hex to binary
        // process each number and form parts
        binary.value = tableOctHexToBin(valueOctHex: hexadecimal, table: table)
        
        return binary
    }

    
}
