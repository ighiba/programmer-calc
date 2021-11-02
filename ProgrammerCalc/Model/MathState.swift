//
//  MathState.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 02.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol MathStateProtocol {
    // Buffer value
    var buffValue: NumberSystemProtocol { get set }
    // Calculation operation
    var operation: CalcMath.Operation { get set }
    // Last result (after calcualtion)
    var lastResult: NumberSystemProtocol? { get set }
    // Inputting state
    var inputStart: Bool { get set }
}

class MathState: MathStateProtocol {
    var buffValue: NumberSystemProtocol
    var operation: CalcMath.Operation
    var lastResult: NumberSystemProtocol?
    var inputStart: Bool = false
    
    init(buffValue: NumberSystemProtocol, operation: CalcMath.Operation) {
        self.buffValue = buffValue
        self.operation = operation
    }
}
