//
//  ConversionModel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol ConversionSettingsProtocol {
    var systemMain: String { get set }
    var systemConverter: String { get set }
    var numbersAfterPoint: Float { get set }
}

class ConversionSettings: ConversionSettingsProtocol, Decodable, Encodable {
    
    var systemMain: String
    var systemConverter: String
    var numbersAfterPoint: Float
    
    
    init(systMain: String, systConverter: String, number: Float) {
        self.systemMain = systMain
        self.systemConverter = systConverter
        self.numbersAfterPoint = number
    }
    
}

class ConversionModel {
   public enum ConversionSystemsEnum: String {
        case bin = "Binary"
        case dec = "Decimal"
        case oct = "Octal"
        case hex = "Hexadecimal"
    }
    
    var conversionSystems = ["Binary", "Decimal", "Octal", "Hexadecimal"]
    
}
