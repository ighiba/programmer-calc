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

    static let shared: StyleSettings = StyleSettings()
    
    // MARK: - Properties
    
    var isUsingSystemAppearance: Bool
    var currentStyle: StyleType
    
    init(isUsingSystemAppearance: Bool = false, currentStyle: StyleType = .dark) {
        self.isUsingSystemAppearance = isUsingSystemAppearance
        self.currentStyle = currentStyle
    }
    
    func setStyleSettings(_ newStyleSettings: StyleSettingsProtocol) {
        isUsingSystemAppearance = newStyleSettings.isUsingSystemAppearance
        currentStyle = newStyleSettings.currentStyle
    }
}

extension StyleSettings: Storable {
    static var storageKey: String { "styleSettings" }
    
    static func getDefault() -> StyleSettings {
        return StyleSettings()
    }
    
    func set(_ data: StyleSettings) {
        isUsingSystemAppearance = data.isUsingSystemAppearance
        currentStyle = data.currentStyle
    }
}
