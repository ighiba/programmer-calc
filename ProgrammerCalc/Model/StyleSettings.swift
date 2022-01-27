//
//  StyleSettings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 27.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import Foundation

protocol StyleSettingsProtocol {
    var isUsingSystemAppearance: Bool { get set }
    var currentStyle: StyleType { get set}
}

class StyleSettings: StyleSettingsProtocol, Decodable, Encodable {
    // MARK: - Properties
    
    static let shared: StyleSettings = StyleSettings(isUsingSystemAppearance: false, currentStyle: .dark)
    
    var isUsingSystemAppearance: Bool
    var currentStyle: StyleType
    
    init(isUsingSystemAppearance: Bool, currentStyle: StyleType) {
        self.isUsingSystemAppearance = isUsingSystemAppearance
        self.currentStyle = currentStyle
    }
    
    func setStyleSettings(_ newStyleSettings: StyleSettingsProtocol) {
        self.isUsingSystemAppearance = newStyleSettings.isUsingSystemAppearance
        self.currentStyle = newStyleSettings.currentStyle
    }
    
}
