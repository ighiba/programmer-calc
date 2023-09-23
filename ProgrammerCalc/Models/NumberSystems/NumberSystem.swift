//
//  NumberSystem.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 14.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol NumberSystemProtocol {
    var value: String { get set }
    var isSigned: Bool { get set }
    
    init(stringLiteral: String)

    func toBinary() -> Binary
}
