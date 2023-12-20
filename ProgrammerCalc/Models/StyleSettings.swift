//
//  StyleSettings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 27.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import UIKit

protocol StyleSettingsProtocol {
    var isUsingSystemAppearance: Bool { get set }
    var theme: Theme { get set}
}

final class StyleSettings: StyleSettingsProtocol {

    static let shared: StyleSettings = StyleSettings()
    
    var isUsingSystemAppearance: Bool
    var theme: Theme
    
    init(isUsingSystemAppearance: Bool = false, theme: Theme = .dark) {
        self.isUsingSystemAppearance = isUsingSystemAppearance
        self.theme = theme
    }
    
    func updateTheme(forInterfaceStyle interfaceStyle: UIUserInterfaceStyle) {
        theme = obtainTheme(forInterfaceStyle: interfaceStyle)
    }
    
    private func obtainTheme(forInterfaceStyle interfaceStyle: UIUserInterfaceStyle) -> Theme {
        switch interfaceStyle {
        case .light, .unspecified:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .dark
        }
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
