//
//  ConversionValues.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class ConversionValues {
    fileprivate let digitValues: Set<String> = ["00","0","1","2","3","4","5","6","7","8","8","9"]
    fileprivate let charValues: Set<String> = ["A","B","C","D","E","F","FF"]
    
    lazy var forbidden = [ "Binary": digitValues.union(charValues).subtracting(["1","0", "00"]),
                           "Decimal": charValues,
                           "Octal": charValues.union(["8","9"]),
                           "Hexadecimal": []]
}
