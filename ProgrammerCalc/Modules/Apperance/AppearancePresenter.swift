//
//  AppearancePresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol AppearanceOutput: AnyObject {
    func updateStyleSettings()
    func updateCheckmarkIndex()
    func themeRowDidSelect(at row: Int)
    func useSystemAppearanceSwitchDidChange(isOn: Bool)
}

final class AppearancePresenter: AppearanceOutput {
    
    // MARK: - Properties
    
    weak var view: AppearanceInput!

    var storage: CalculatorStorage!
    var styleFactory: StyleFactory!
    var styleSettings: StyleSettings!
    
    // MARK: - Methods

    func updateStyleSettings() {
        updateCheckmarkIndex()
        updateUseSystemAppearanceSwitch()
    }
    
    func updateCheckmarkIndex() {
        let checkmarkedRow = styleSettings.theme.rawValue
        view.setCheckmarkedTheme(atRow: checkmarkedRow)
    }
    
    func updateUseSystemAppearanceSwitch() {
        let isUsingSystemAppearance = styleSettings.isUsingSystemAppearance
        view.setUseSystemAppearanceSwitch(isOn: isUsingSystemAppearance)
    }
    
    func themeRowDidSelect(at row: Int) {
        guard let theme = Theme(rawValue: row) else { return }
        
        styleSettings.theme = theme
        storage.saveData(styleSettings)
        
        updateStyle()
    }
    
    func useSystemAppearanceSwitchDidChange(isOn isUsingSystemAppearance: Bool) {
        styleSettings.isUsingSystemAppearance = isUsingSystemAppearance
        
        if styleSettings.isUsingSystemAppearance {
            let interfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
            updateThemeSettings(forInterfaceStyle: interfaceStyle)
        }
        
        storage.saveData(styleSettings)
        
        let style = styleFactory.get(theme: styleSettings.theme)
        let checkmarkedRow = styleSettings.theme.rawValue
        
        view.setCheckmarkedTheme(atRow: checkmarkedRow)
        view.setUseSystemAppearanceSwitch(isOn: isUsingSystemAppearance)
        view.reloadTable()
        view.updateNavBarStyle(style)
        view.animateUpdateRootViewLayoutSubviews()
    }
    
    private func updateStyle() {
        let interfaceStyle: UIUserInterfaceStyle
        if styleSettings.isUsingSystemAppearance {
            interfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
            updateThemeSettings(forInterfaceStyle: interfaceStyle)
        } else {
            interfaceStyle = styleSettings.theme == .light ? .light : .dark
        }
        
        storage.saveData(styleSettings)
        
        let style = styleFactory.get(theme: styleSettings.theme)
        
        view.updateLayout(interfaceStyle: interfaceStyle)
        view.updateNavBarStyle(style)
        view.animateUpdateRootViewLayoutSubviews()
    }
    
    private func updateThemeSettings(forInterfaceStyle interfaceStyle: UIUserInterfaceStyle) {
        let theme = obtainTheme(forInterfaceStyle: interfaceStyle)
        styleSettings.theme = theme
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
