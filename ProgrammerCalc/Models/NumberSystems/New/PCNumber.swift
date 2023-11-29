//
//  PCNumber.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 29.11.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol PCNumber {
    var pcDecimalValue: PCDecimal { get }
    init(pcDecimal: PCDecimal)
}

extension PCDecimal: PCNumber {
    var pcDecimalValue: PCDecimal { self }
    
    init(pcDecimal: PCDecimal) {
        self.init(value: pcDecimal.decimalValue)
    }
}
