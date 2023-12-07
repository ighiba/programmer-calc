//
//  PCNumber.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.11.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol PCNumber: CustomStringConvertible {
    var pcDecimalValue: PCDecimal { get }
    init(pcDecimal: PCDecimal)
    init(pcDecimal: PCDecimal, bitWidth: UInt8, isSigned: Bool)
    mutating func reset()
}
