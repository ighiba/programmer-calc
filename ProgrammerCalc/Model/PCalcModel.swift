//
//  PCalcModel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 26.07.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

struct CalcState {
    
    enum mathOperation {
        case add
        case sub
        case mul
        case div
    }
    
    var buffValue: String
    var operation: mathOperation
    var lastResult: String?
    var inputStart: Bool = false
    
    init(buffValue:String, operation: mathOperation) {
        self.buffValue = buffValue
        self.operation = operation
    }
}
