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
    var theme: Theme { get set}
}

final class StyleSettings: StyleSettingsProtocol {

    static let shared: StyleSettings = StyleSettings()
    
    // MARK: - Properties
    
    var isUsingSystemAppearance: Bool
    var theme: Theme
    
    init(isUsingSystemAppearance: Bool = false, theme: Theme = .dark) {
        self.isUsingSystemAppearance = isUsingSystemAppearance
        self.theme = theme
    }
}

extension StyleSettings: Storable {
    static var storageKey: String { "styleSettings" }
    
    static func getDefault() -> StyleSettings {
        return StyleSettings()
    }
    
    func set(_ data: StyleSettings) {
        isUsingSystemAppearance = data.isUsingSystemAppearance
        theme = data.theme
    }
}
