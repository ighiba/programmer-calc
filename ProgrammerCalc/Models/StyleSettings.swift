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
    var styleType: StyleType { get set}
}

final class StyleSettings: StyleSettingsProtocol {

    static let shared: StyleSettings = StyleSettings()
    
    // MARK: - Properties
    
    var isUsingSystemAppearance: Bool
    var styleType: StyleType
    
    init(isUsingSystemAppearance: Bool = false, styleType: StyleType = .dark) {
        self.isUsingSystemAppearance = isUsingSystemAppearance
        self.styleType = styleType
    }
}

extension StyleSettings: Storable {
    static var storageKey: String { "styleSettings" }
    
    static func getDefault() -> StyleSettings {
        return StyleSettings()
    }
    
    func set(_ data: StyleSettings) {
        isUsingSystemAppearance = data.isUsingSystemAppearance
        styleType = data.styleType
    }
}
