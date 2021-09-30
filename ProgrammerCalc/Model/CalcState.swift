//
//  CalcState.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol CalcStateProtocol {
    var mainLabelState: String { get set }
    var converterLabelState: String { get set }
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
