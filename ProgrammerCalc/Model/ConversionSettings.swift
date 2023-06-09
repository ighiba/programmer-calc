//
//  ConversionSettings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol ConversionSettingsProtocol {
    // Conversion system from
    var systemMain: ConversionSystemsEnum { get set }
    // Conversion system to
    var systemConverter: ConversionSystemsEnum { get set }
    // // Number of digits after point
    var numbersAfterPoint: Int { get set }
}

final class ConversionSettings: ConversionSettingsProtocol {
    
    static let shared: ConversionSettings = ConversionSettings(systMain: .dec, systConverter: .dec, number: 8)
    
    var systemMain: ConversionSystemsEnum
    var systemConverter: ConversionSystemsEnum
    var numbersAfterPoint: Int
    
    init(systMain: ConversionSystemsEnum, systConverter: ConversionSystemsEnum, number: Int) {
        self.systemMain = systMain
        self.systemConverter = systConverter
        self.numbersAfterPoint = number
    }
    
    func setConversionSettings(_ newSettings: ConversionSettingsProtocol) {
        self.systemMain = newSettings.systemMain
        self.systemConverter = newSettings.systemConverter
        self.numbersAfterPoint = newSettings.numbersAfterPoint
    }
}

extension ConversionSettings: Storable {
    static var storageKey: String {
        return "conversionSettings"
    }
    
    static func getDefault() -> ConversionSettings {
        return ConversionSettings(systMain: .dec, systConverter: .dec, number: 8)
    }
    
    func set(_ data: ConversionSettings) {
        self.systemMain = data.systemMain
        self.systemConverter = data.systemConverter
        self.numbersAfterPoint = data.numbersAfterPoint
    }
}

enum ConversionSystemsEnum: String, CaseIterable, Decodable, Encodable {
     case bin = "Binary"
     case dec = "Decimal"
     case oct = "Octal"
     case hex = "Hexadecimal"
 }
