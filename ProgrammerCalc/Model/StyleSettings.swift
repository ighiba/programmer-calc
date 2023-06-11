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

final class StyleSettings: StyleSettingsProtocol {

    static let shared: StyleSettings = StyleSettings(isUsingSystemAppearance: false, currentStyle: .dark)
    
    // MARK: - Properties
    
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

extension StyleSettings: Storable {
    static var storageKey: String {
        return "styleSettings"
    }
    
    static func getDefault() -> StyleSettings {
        return StyleSettings(isUsingSystemAppearance: false, currentStyle: .dark)
    }
    
    func set(_ data: StyleSettings) {
        self.isUsingSystemAppearance = data.isUsingSystemAppearance
        self.currentStyle = data.currentStyle
    }
}
