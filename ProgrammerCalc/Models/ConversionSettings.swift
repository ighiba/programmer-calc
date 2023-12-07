//
//  ConversionSettings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol ConversionSettingsProtocol {
    var systemMain: ConversionSystem { get set }
    var systemConverter: ConversionSystem { get set }
    var numbersAfterPoint: Int { get set }
    var fractionalWidth: UInt8 { get }
}

final class ConversionSettings: ConversionSettingsProtocol {
    
    static let shared: ConversionSettings = ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
    
    var systemMain: ConversionSystem
    var systemConverter: ConversionSystem
    var numbersAfterPoint: Int
    var fractionalWidth: UInt8 { UInt8(numbersAfterPoint) }
    
    init(systMain: ConversionSystem, systConverter: ConversionSystem, number: Int) {
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
    
    static var storageKey: String { "conversionSettings" }
    
    static func getDefault() -> ConversionSettings {
        return ConversionSettings(systMain: .dec, systConverter: .bin, number: 8)
    }
    
    func set(_ data: ConversionSettings) {
        systemMain = data.systemMain
        systemConverter = data.systemConverter
        numbersAfterPoint = data.numbersAfterPoint
    }
}

enum ConversionSystem: Int, CaseIterable, Codable {
    case bin = 0
    case dec = 1
    case oct = 2
    case hex = 3
    
    var title: String {
        switch self {
        case .bin:
            return "Binary"
        case .dec:
            return "Decimal"
        case .oct:
            return "Octal"
        case .hex:
            return "Hexadecimal"
        }
    }
 }
