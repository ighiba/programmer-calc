//
//  Octal.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

final class Octal: NumberSystemProtocol {
    
    // MARK: - Properties
    
    private let octHexHelper = OctHexHelperOld()
    
    var value: String = "0"
    var isSigned: Bool = false

    // oct table for converting from binary to oct
    // from 0 to 7
    private let table: [String : String] = [
        "000" : "0",
        "001" : "1",
        "010" : "2",
        "011" : "3",
        "100" : "4",
        "101" : "5",
        "110" : "6",
        "111" : "7"
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
        let octal = binary.convertBinaryToOct(octTable: table)
        self.value = octal.value
    }
    
    // MARK: - Methods
    
    func toBinary() -> Binary {
        let binary = Binary()

        binary.value = octHexHelper.tableOctHexToBin(valueOctHex: value, table: table)

        return binary
    }
}
