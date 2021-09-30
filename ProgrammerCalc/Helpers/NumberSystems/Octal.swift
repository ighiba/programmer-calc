//
//  Octal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class Octal: OctHexHelper, NumberSystemProtocol {
    
    // ==================
    // MARK: - Properties
    // ==================
    
    var value: String = ""
    var isSigned: Bool = false // default

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
        self.value = value
    }
    
    /// Creates an empty instance
    override init() {
        super.init()
    }
    
    /// Creates an instance initialized to the Binary value
    init(_ valueBin: Binary) {
        let octal = valueBin.convertBinaryToOct(octTable: table)
        self.value = octal.value
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // OCT -> BIN
    // Convert from oct to binary with table helper
    func convertOctToBinary() -> Binary {
        let octal = self.value
        let binary = Binary()
        
        // from oct to binary
        // process each number and form parts
        binary.value = tableOctHexToBin(valueOctHex: octal, table: table)
        
        return binary
    }
    
}
