//
//  CalcState.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation



protocol CalcStateProtocol {
    // Last PCDecimal value from input (in Calculator)
    var lastValue: PCDecimal { get set }
    // Last string values from input/output labels
    var lastLabelValues: LabelValues { get set }
    // State from signed on/off button
    var processSigned: Bool { get set }
}

final class CalcState: CalcStateProtocol {
    
    static let shared: CalcState = CalcState(lastValue: PCDecimal(0),
                                          lastLabelValues: LabelValues(main: "0", converter: "0"),
                                          processSigned: false)
    
    var lastValue: PCDecimal
    var lastLabelValues: LabelValues
    var processSigned: Bool
    
    init(lastValue: PCDecimal, lastLabelValues: LabelValues, processSigned: Bool) {
        self.lastValue = lastValue
        self.lastLabelValues = lastLabelValues
        self.processSigned = processSigned
    }
    
    func setCalcState(_ newCalcState: CalcStateProtocol) {
        self.lastValue = newCalcState.lastValue
        self.lastLabelValues = newCalcState.lastLabelValues
        self.processSigned = newCalcState.processSigned
    }
    
    func updateMainValue(_ main: String) {
        self.lastLabelValues = LabelValues(main: main, converter: self.lastLabelValues.converter)
    }
    
    func updateConverterValue(_ converter: String) {
        self.lastLabelValues = LabelValues(main: self.lastLabelValues.main, converter: converter)
    }
}

extension CalcState: Storable {
    static var storageKey: String {
        return "calcState"
    }
    
    static func getDefault() -> CalcState {
        return CalcState(lastValue: PCDecimal(0),
                        lastLabelValues: LabelValues(main: "0", converter: "0"),
                        processSigned: false)
    }
    
    func set(_ data: CalcState) {
        self.lastValue = data.lastValue
        self.lastLabelValues = data.lastLabelValues
        self.processSigned = data.processSigned
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
