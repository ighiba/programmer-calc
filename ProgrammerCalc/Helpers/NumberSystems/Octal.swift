//
//  Octal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class Octal: NumberSystem {

    // table for converting from binary to oct
    let table = [   "000":"0",
                    "001":"1",
                    "010":"2",
                    "011":"3",
                    "100":"4",
                    "101":"5",
                    "110":"6",
                    "111":"7",]
    
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
        let octal = valueBin.convertBinaryToOct(octTable: table)
        self.value = octal.value
    }
    
    // =======
    // Methods
    // =======
    
    // OCT -> BIN
    // Convert from oct to binary with table helper
    func convertOctToBinary() -> Binary {
        let octal = self.value
        let binary = Binary()
        
        //let partition: Int = 3
        
        // TODO: Remove spaces

        // from hex to binary
        // process each number and form parts
        binary.value = tableOctHexToBin(valueOctHex: octal, table: table)
        
        return binary
    }
    
    
    
}
