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
    var mainLabelState: String
    var converterLabelState: String
    var processSigned: Bool
    
    init(mainState:String, convertState: String, processSigned: Bool) {
        self.mainLabelState = mainState
        self.converterLabelState = convertState
        self.processSigned = processSigned
    }
    
}
