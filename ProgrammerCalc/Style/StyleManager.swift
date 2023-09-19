//
//  StyleManager.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class StyleManager {
    
    static let shared = StyleManager()
    
    var currentStyle: Style { styleFactory.get(style: styleSettings.currentStyle) }
    
    private let styleSettings = StyleSettings.shared
    private let styleFactory = StyleFactory()
    
    private init() {}
    
    func updateStyle(for window: UIWindow?) {
        if styleSettings.isUsingSystemAppearance {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                styleSettings.currentStyle = .light
            case .dark:
                styleSettings.currentStyle = .dark
            @unknown default:
                styleSettings.currentStyle = .dark
            }
            window?.overrideUserInterfaceStyle = .unspecified
        } else {
            window?.overrideUserInterfaceStyle = styleSettings.currentStyle == .light ? .light : .dark
        }
    }
}
