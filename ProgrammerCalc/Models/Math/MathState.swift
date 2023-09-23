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
    var operation: CalcMath.OperationType { get set }
    // Last result (after calcualtion)
    var lastResult: NumberSystemProtocol? { get set }
}

class MathState: MathStateProtocol {
    var buffValue: NumberSystemProtocol
    var operation: CalcMath.OperationType
    var lastResult: NumberSystemProtocol?
    
    init(buffValue: NumberSystemProtocol, operation: CalcMath.OperationType) {
        self.buffValue = buffValue
        self.operation = operation
    }
}
