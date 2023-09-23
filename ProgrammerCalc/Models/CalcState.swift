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

final class CalcState: CalcStateProtocol {
    
    static let shared: CalcState = CalcState()
    
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
        lastLabelValues = LabelValues(main: main, converter: lastLabelValues.converter)
    }
    
    func updateConverterValue(_ converter: String) {
        lastLabelValues = LabelValues(main: lastLabelValues.main, converter: converter)
    }
}

extension CalcState: Storable {
    static var storageKey: String { "calcState" }
    
    static func getDefault() -> CalcState {
        return CalcState()
    }
    
    func set(_ data: CalcState) {
        lastValue = data.lastValue
        lastLabelValues = data.lastLabelValues
        processSigned = data.processSigned
    }
}

class LabelValues: Decodable, Encodable {
    var main: String
    var converter: String
    
    init(main: String, converter: String) {
        self.main = main
        self.converter = converter
    }
}
