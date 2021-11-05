//
//  ConversionValues.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class ConversionValues {
    
    static func getForbiddenValues() -> [ConversionSystemsEnum : Set<String>] {
        
        let digitValues: Set<String> = ["00","0","1","2","3","4","5","6","7","8","8","9"]
        let charValues: Set<String> = ["A","B","C","D","E","F","FF"]
        let forbidden: [ConversionSystemsEnum : Set<String>]
        
        forbidden = [ .bin : digitValues.union(charValues).subtracting(["1","0","00"]),
                      .dec : charValues,
                      .oct: charValues.union(["8","9"]),
                      .hex: []]

        return forbidden
    }
    
    static func getAllowedValues() -> [ConversionSystemsEnum : Set<String>] {
        
        let digitValues: Set<String> = [".","-","00","0","1","2","3","4","5","6","7","8","8","9"]
        let charValues: Set<String> = ["A","B","C","D","E","F","FF"]
        let allowed: [ConversionSystemsEnum : Set<String>]
        
        allowed = [ .bin : digitValues.intersection(["00","0","1"]),
                      .dec : digitValues,
                      .oct: digitValues.subtracting(["8","9"]),
                      .hex: digitValues.union(charValues)]

        return allowed
    }
}
