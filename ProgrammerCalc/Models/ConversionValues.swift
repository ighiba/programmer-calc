//
//  ConversionValues.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

private let digitValues: Set<String> = ["00", "0", "1", "2", "3", "4", "5", "6", "7", "8", "8", "9"]
private let charValues: Set<String> = ["A", "B", "C", "D", "E", "F", "FF"]

class ConversionValues {
    static var allowed: [ConversionSystem : Set<String>] {
        return [
            .bin : digitValues.intersection(["00", "0", "1"]),
            .dec : digitValues,
            .oct : digitValues.subtracting(["8", "9"]),
            .hex : digitValues.union(charValues)
        ]
    }
    
    static var forbidden: [ConversionSystem : Set<String>] {
        return [
            .bin : digitValues.union(charValues).subtracting(["1", "0", "00"]),
            .dec : charValues,
            .oct : charValues.union(["8", "9"]),
            .hex : []
        ]
    }
    
    static func getForbidden(for system: ConversionSystem) -> Set<String> {
        return forbidden[system]!
    }
    
    static func getAllowed(for system: ConversionSystem) -> Set<String> {
        return allowed[system]!
    }
}
