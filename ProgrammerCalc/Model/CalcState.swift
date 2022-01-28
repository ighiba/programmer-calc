//
//  CalcState.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol CalcStateProtocol {
    // Last string value from mainLabel (Input)
    var mainLabelState: String { get set }
    // Last string value from converterLabel (Output)
    var converterLabelState: String { get set }
    // State from signed on/off button
    var processSigned: Bool { get set }
}

class CalcState: CalcStateProtocol, Decodable, Encodable {
    
    static let shared: CalcState = CalcState(mainState: "0", convertState: "0", processSigned: false)
    
    var mainLabelState: String
    var converterLabelState: String
    var processSigned: Bool
    
    init(mainState:String, convertState: String, processSigned: Bool) {
        self.mainLabelState = mainState
        self.converterLabelState = convertState
        self.processSigned = processSigned
    }
    
    func setCalcState(_ newCalcState: CalcStateProtocol) {
        self.mainLabelState = newCalcState.mainLabelState
        self.converterLabelState = newCalcState.converterLabelState
        self.processSigned = newCalcState.processSigned
    }
    
}
