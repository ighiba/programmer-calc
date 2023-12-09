//
//  Hexadecimal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

final class Hexadecimal: NumberSystemProtocol {
    
    // MARK: - Properties
    
    //private let octHexHelper = OctHexHelperOld()
    
    var value: String = "0"
    var isSigned: Bool = false

    // hex table for converting from binary to hex
    // from 0 to 15
    private let table: [String : String] = [
        "0000" : "0",
        "0001" : "1",
        "0010" : "2",
        "0011" : "3",
        "0100" : "4",
        "0101" : "5",
        "0110" : "6",
        "0111" : "7",
        "1000" : "8",
        "1001" : "9",
        "1010" : "A",
        "1011" : "B",
        "1100" : "C",
        "1101" : "D",
        "1110" : "E",
        "1111" : "F"
    ]
    
    required public init(stringLiteral value: String) {
        self.value = value
    }
    
    /// Creates an empty instance
    init() {
        self.value = "0"
    }
    
    /// Creates an instance initialized to the Binary value
    init(_ binary: Binary) {
        let hexadecimal = binary.convertBinaryToHex(hexTable: table)
        self.value = hexadecimal.value
    }
    
    // MARK: - Methods
    
    func toBinary() -> Binary {
        let binary = Binary()
        
        //binary.value = octHexHelper.tableOctHexToBin(valueOctHex: value, table: table)
        
        return binary
    }
}
