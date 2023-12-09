//
//  CalcState.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol CalcStateProtocol {
    var lastValue: PCDecimal { get set }
    var lastLabelValues: LabelValues { get set }
    var processSigned: Bool { get set }
}

final class CalculatorState: CalcStateProtocol {
    
    static let shared: CalculatorState = CalculatorState()
    
    var lastValue: PCDecimal
    var lastLabelValues: LabelValues
    var processSigned: Bool
    
    convenience init() {
        self.init(lastValue: .zero, lastLabelValues: LabelValues(main: "0", converter: "0"), processSigned: false)
    }
    
    init(lastValue: PCDecimal, lastLabelValues: LabelValues, processSigned: Bool) {
        self.lastValue = lastValue
        self.lastLabelValues = lastLabelValues
        self.processSigned = processSigned
    }
    
    func setCalcState(_ newCalcState: CalcStateProtocol) {
        lastValue = newCalcState.lastValue
        lastLabelValues = newCalcState.lastLabelValues
        processSigned = newCalcState.processSigned
    }
    
    func updateMainValue(_ main: String) {
        lastLabelValues = LabelValues(main: main, converter: lastLabelValues.output)
    }
    
    func updateConverterValue(_ converter: String) {
        lastLabelValues = LabelValues(main: lastLabelValues.input, converter: converter)
    }
}

extension CalculatorState: Storable {
    static var storageKey: String { "calcState" }
    
    static func getDefault() -> CalculatorState {
        return CalculatorState()
    }
    
    func set(_ data: CalculatorState) {
        lastValue = data.lastValue
        lastLabelValues = data.lastLabelValues
        processSigned = data.processSigned
    }
}

class LabelValues: Decodable, Encodable {
    var input: String
    var output: String
    
    init(main: String, converter: String) {
        self.input = main
        self.output = converter
    }
}
