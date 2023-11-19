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

extension NumberSystemProtocol {
    
    typealias IntPart = String
    typealias FractPart = String
    
    func divideIntFract(str: String) -> (intPart: IntPart?, fractPart: FractPart?) {
        var intPartStr: String
        var fractPartStr: String
        
        if let pointPosition = str.firstIndex(of: ".") {
            let intPartRange = str.startIndex ..< pointPosition
            let fractPartRange = pointPosition ..< str.endIndex
            
            intPartStr = String(str[intPartRange])
            fractPartStr = String(str[fractPartRange])
            fractPartStr.removeFirst()
           
            return (intPartStr, fractPartStr)
        } else {
            return (str, nil)
        }
    }
}
