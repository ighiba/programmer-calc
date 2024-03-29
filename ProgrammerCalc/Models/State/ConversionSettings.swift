//
//  ConversionSettings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol ConversionSettingsProtocol {
    var inputSystem: ConversionSystem { get set }
    var outputSystem: ConversionSystem { get set }
    var fractionalWidth: UInt8 { get set }
}

final class ConversionSettings: ConversionSettingsProtocol {
    
    static let shared: ConversionSettings = ConversionSettings(inputSystem: .dec, outputSystem: .bin, fractionalWidth: 8)
    
    var inputSystem: ConversionSystem
    var outputSystem: ConversionSystem
    var fractionalWidth: UInt8
    
    init(inputSystem: ConversionSystem, outputSystem: ConversionSystem, fractionalWidth: UInt8) {
        self.inputSystem = inputSystem
        self.outputSystem = outputSystem
        self.fractionalWidth = fractionalWidth
    }
}

extension ConversionSettings: Storable {
    
    static var storageKey: String { "conversionSettings" }
    
    static func getDefault() -> ConversionSettings {
        return ConversionSettings(inputSystem: .dec, outputSystem: .bin, fractionalWidth: 8)
    }
    
    func set(_ data: ConversionSettings) {
        inputSystem = data.inputSystem
        outputSystem = data.outputSystem
        fractionalWidth = data.fractionalWidth
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
    
    var shortTitle: String {
        switch self {
        case .bin:
            return "BIN"
        case .dec:
            return "DEC"
        case .oct:
            return "OCT"
        case .hex:
            return "HEX"
        }
    }
 }
