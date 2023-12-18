//
//  Style.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

enum Theme: Int, CaseIterable, Codable {
    case light = 0
    case dark = 1
    case oldschool = 2
    
    var stringValue: String {
        switch self {
        case .light:
            return "light"
        case .dark:
            return "dark"
        case .oldschool:
            return "oldschool"
        }
    }
    
    var localizedTitle: String {
        switch self {
        case .light:
            return NSLocalizedString("Light Mode", comment: "")
        case .dark:
            return NSLocalizedString("Dark Mode", comment: "")
        case .oldschool:
            return NSLocalizedString("Old School", comment: "")
        }
    }
}

protocol StyleProtocol {
    var backgroundColor: UIColor { get }
    var labelTextColor: UIColor { get }
    var secondaryLabelTextColor:  UIColor { get }
    var tintColor: UIColor { get }
    var numericButtonStyle: ButtonStyleProtocol { get }
    var actionButtonStyle: ButtonStyleProtocol { get }
    var miscButtonStyle: ButtonStyleProtocol { get }
    var buttonBorderColor: UIColor { get }
    var bitButtonColor: UIColor { get }
}

class Style: StyleProtocol {
    var backgroundColor: UIColor
    var labelTextColor: UIColor
    var secondaryLabelTextColor: UIColor
    var tintColor: UIColor
    var numericButtonStyle: ButtonStyleProtocol
    var actionButtonStyle: ButtonStyleProtocol
    var miscButtonStyle: ButtonStyleProtocol
    var buttonBorderColor: UIColor
    var bitButtonColor: UIColor
    
    init(
        backgroundColor: UIColor,
        labelTextColor: UIColor,
        secondaryLabelTextColor: UIColor,
        tintColor: UIColor,
        numericButtonStyle: ButtonStyleProtocol,
        actionButtonStyle: ButtonStyleProtocol,
        miscButtonStyle: ButtonStyleProtocol,
        buttonBorderColor: UIColor,
        bitButtonColor: UIColor
    ) {
        self.backgroundColor = backgroundColor
        self.labelTextColor = labelTextColor
        self.secondaryLabelTextColor = secondaryLabelTextColor
        self.tintColor = tintColor
        self.numericButtonStyle = numericButtonStyle
        self.actionButtonStyle = actionButtonStyle
        self.miscButtonStyle = miscButtonStyle
        self.buttonBorderColor = buttonBorderColor
        self.bitButtonColor = bitButtonColor
    }
}

extension Style {
    static let light: Style = Style(
        backgroundColor: UIColor(named: "LightTheme/BackgroundColor")!,
        labelTextColor: UIColor(named: "LightTheme/LabelTextColor")!,
        secondaryLabelTextColor: UIColor(named: "LightTheme/SecondaryLabelTextColor")!,
        tintColor: UIColor(named: "LightTheme/TintColor")!,
        numericButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "LightTheme/NumericButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "LightTheme/NumericButton/BackgroundColor")!.darker(by: 0.5),
            textColor:          UIColor(named: "LightTheme/NumericButton/TextColor")!,
            textTintColor:      UIColor(named: "LightTheme/NumericButton/TextTintColor")!
        ),
        actionButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "LightTheme/ActionButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "LightTheme/ActionButton/BackgroundColor")!.darker(by: 0.5),
            textColor:          UIColor(named: "LightTheme/ActionButton/TextColor")!,
            textTintColor:      UIColor(named: "LightTheme/ActionButton/TextTintColor")!
        ),
        miscButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "LightTheme/MiscButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "LightTheme/MiscButton/BackgroundColor")!.darker(by: 0.5),
            textColor:          UIColor(named: "LightTheme/MiscButton/TextColor")!,
            textTintColor:      UIColor(named: "LightTheme/MiscButton/TextTintColor")!
        ),
        buttonBorderColor: UIColor(named: "LightTheme/ButtonBorderColor")!,
        bitButtonColor: UIColor(named: "LightTheme/BitButtonColor")!
    )
    
    static let dark: Style = Style(
        backgroundColor: UIColor(named: "DarkTheme/BackgroundColor")!,
        labelTextColor: UIColor(named: "DarkTheme/LabelTextColor")!,
        secondaryLabelTextColor: UIColor(named: "DarkTheme/SecondaryLabelTextColor")!,
        tintColor: UIColor(named: "DarkTheme/TintColor")!,
        numericButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "DarkTheme/NumericButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "DarkTheme/NumericButton/BackgroundColor")!.lighter(by: 0.5),
            textColor:          UIColor(named: "DarkTheme/NumericButton/TextColor")!,
            textTintColor:      UIColor(named: "DarkTheme/NumericButton/TextTintColor")!
        ),
        actionButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "DarkTheme/ActionButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "DarkTheme/ActionButton/BackgroundColor")!.lighter(by: 0.25),
            textColor:          UIColor(named: "DarkTheme/ActionButton/TextColor")!,
            textTintColor:      UIColor(named: "DarkTheme/ActionButton/TextTintColor")!
        ),
        miscButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "DarkTheme/MiscButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "DarkTheme/MiscButton/BackgroundColor")!.lighter(by: 0.25),
            textColor:          UIColor(named: "DarkTheme/MiscButton/TextColor")!,
            textTintColor:      UIColor(named: "DarkTheme/MiscButton/TextTintColor")!
        ),
        buttonBorderColor: UIColor(named: "DarkTheme/ButtonBorderColor")!,
        bitButtonColor: UIColor(named: "DarkTheme/BitButtonColor")!
    )
    
    static let oldSchool: Style = Style(
        backgroundColor: UIColor(named: "OldSchoolTheme/BackgroundColor")!,
        labelTextColor: UIColor(named: "OldSchoolTheme/LabelTextColor")!,
        secondaryLabelTextColor: UIColor(named: "OldSchoolTheme/SecondaryLabelTextColor")!,
        tintColor: UIColor(named: "OldSchoolTheme/TintColor")!,
        numericButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "OldSchoolTheme/NumericButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "OldSchoolTheme/NumericButton/BackgroundColor")!.darker(by: 0.5),
            textColor:          UIColor(named: "OldSchoolTheme/NumericButton/TextColor")!,
            textTintColor:      UIColor(named: "OldSchoolTheme/NumericButton/TextTintColor")!
        ),
        actionButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "OldSchoolTheme/ActionButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "OldSchoolTheme/ActionButton/BackgroundColor")!.darker(by: 0.5),
            textColor:          UIColor(named: "OldSchoolTheme/ActionButton/TextColor")!,
            textTintColor:      UIColor(named: "OldSchoolTheme/ActionButton/TextTintColor")!
        ),
        miscButtonStyle: ButtonStyle(
            backgroundColor:     UIColor(named: "OldSchoolTheme/MiscButton/BackgroundColor")!,
            backgroundTintColor: UIColor(named: "OldSchoolTheme/MiscButton/BackgroundColor")!.darker(by: 0.5),
            textColor:          UIColor(named: "OldSchoolTheme/MiscButton/TextColor")!,
            textTintColor:      UIColor(named: "OldSchoolTheme/MiscButton/TextTintColor")!
        ),
        buttonBorderColor: UIColor(named: "OldSchoolTheme/ButtonBorderColor")!,
        bitButtonColor: UIColor(named: "OldSchoolTheme/BitButtonColor")!
    )
}
