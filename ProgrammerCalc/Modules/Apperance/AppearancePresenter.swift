//
//  AppearancePresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol AppearanceOutput: AnyObject {
    func obtainStyleSettings()
    func obtainCheckmarkIndex()
    func setNewStyle(by row: Int)
    func useSystemAppearance(_ state: Bool)
}

class AppearancePresenter: AppearanceOutput {
    
    // MARK: - Properties
    
    weak var view: AppearanceInput!

    var storage: CalculatorStorage!
    var styleFactory: StyleFactory!
    var styleSettings: StyleSettings!
    
    // MARK: - Methods

    func obtainStyleSettings() {
        view.setCheckmarkIndex(for: styleSettings.currentStyle.rawValue)
        view.setIsUseSystemAppearence(styleSettings.isUsingSystemAppearance)
    }
    
    func obtainCheckmarkIndex() {
        view.setCheckmarkIndex(for: styleSettings.currentStyle.rawValue)
    }
    
    func setNewStyle(by row: Int) {
        let newStyle = StyleType(rawValue: row)!
        styleSettings.currentStyle = newStyle
        storage.saveData(styleSettings)
        updateStyle()
    }
    
    func updateStyle() {
        let interfaceStyle: UIUserInterfaceStyle

        if styleSettings.isUsingSystemAppearance {
            interfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
            updateCurrentStyleBy(interfaceStyle)
        } else {
            interfaceStyle = styleSettings.currentStyle == .light ? .light : .dark
        }
        
        view.updateInterfaceLayout(interfaceStyle)

        let style = styleFactory.get(style: styleSettings.currentStyle)
        view.updateNavBarStyle(style)
        view.animateUpdateRootViewLayoutSubviews()
    }
    
    private func updateCurrentStyleBy(_ interface: UIUserInterfaceStyle) {
        switch interface {
        case .light, .unspecified:
            styleSettings.currentStyle = .light
        case .dark:
            styleSettings.currentStyle = .dark
        @unknown default:
            styleSettings.currentStyle = .dark
        }
        storage.saveData(styleSettings)
    }
    
    func useSystemAppearance(_ state: Bool) {
        styleSettings.isUsingSystemAppearance = state
        storage.saveData(styleSettings)
        
        if styleSettings.isUsingSystemAppearance {
            updateCurrentStyleBy(UIScreen.main.traitCollection.userInterfaceStyle)
        }
        view.setCheckmarkIndex(for: styleSettings.currentStyle.rawValue)
        view.setIsUseSystemAppearence(state)
        view.reloadTable()

        let style = styleFactory.get(style: styleSettings.currentStyle)
        view.updateNavBarStyle(style)
        view.animateUpdateRootViewLayoutSubviews()
    }
}

