//
//  NumberSystem.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol NumberSystemProtocol {
    // raw value
    var value: String { get set }
    // is value signed
    var isSigned: Bool { get set }
    // default init by string
    init(stringLiteral: String)
    
}

