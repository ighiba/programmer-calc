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
    
    var currentStyle: Style { styleFactory.get(theme: styleSettings.theme) }
    
    private let styleSettings = StyleSettings.shared
    private let styleFactory = StyleFactory()
    
    private init() {}
    
    func updateStyle(for window: UIWindow?) {
        if styleSettings.isUsingSystemAppearance {
            let interfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
            styleSettings.updateTheme(forInterfaceStyle: interfaceStyle)
            window?.overrideUserInterfaceStyle = .unspecified
        } else {
            window?.overrideUserInterfaceStyle = styleSettings.preferredInterfaceStyle
        }
    }
}
