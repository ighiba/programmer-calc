//
//  CalculatorState.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol CalcStateProtocol {
    var lastValue: PCDecimal { get set }
    var isSigned: Bool { get set }
    var inputText: String { get set }
    var outputText: String { get set }
}

final class CalculatorState: CalcStateProtocol {
    
    static let shared: CalculatorState = CalculatorState()
    
    var lastValue: PCDecimal
    var isSigned: Bool
    var inputText: String
    var outputText: String
    
    convenience init() {
        self.init(lastValue: .zero, isSigned: true, inputText: "0", outputText: "0")
    }
    
    init(lastValue: PCDecimal, isSigned: Bool, inputText: String, outputText: String) {
        self.lastValue = lastValue
        self.isSigned = isSigned
        self.inputText = inputText
        self.outputText = outputText
    }
}

extension CalculatorState: Storable {
    static var storageKey: String { "calcState" }
    
    static func getDefault() -> CalculatorState {
        return CalculatorState()
    }
    
    func set(_ data: CalculatorState) {
        lastValue = data.lastValue
        isSigned = data.isSigned
        inputText = data.inputText
        outputText = data.outputText
    }
}
