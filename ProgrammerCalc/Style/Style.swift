//
//  Style.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

enum StyleType: Int, CaseIterable, Codable {
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
    var secondayLabelTextColor:  UIColor { get }
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
    var secondayLabelTextColor: UIColor
    var tintColor: UIColor
    var numericButtonStyle: ButtonStyleProtocol
    var actionButtonStyle: ButtonStyleProtocol
    var miscButtonStyle: ButtonStyleProtocol
    var buttonBorderColor: UIColor
    var bitButtonColor: UIColor
    
    init(
        backgroundColor: UIColor,
        labelTextColor: UIColor,
        secondayLabelTextColor: UIColor,
        tintColor: UIColor,
        numericButtonStyle: ButtonStyleProtocol,
        actionButtonStyle: ButtonStyleProtocol,
        miscButtonStyle: ButtonStyleProtocol,
        buttonBorderColor: UIColor,
        bitButtonColor: UIColor
    ) {
        self.backgroundColor = backgroundColor
        self.labelTextColor = labelTextColor
        self.secondayLabelTextColor = secondayLabelTextColor
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
        secondayLabelTextColor: UIColor(named: "LightTheme/SecondaryLabelTextColor")!,
        tintColor: UIColor(named: "LightTheme/TintColor")!,
        numericButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "LightTheme/NumericButton/FrameColor")!,
            frameTint:  UIColor(named: "LightTheme/NumericButton/FrameColor")!.darker(by: 0.5),
            textColor:  UIColor(named: "LightTheme/NumericButton/TextColor")!,
            textTint:   UIColor(named: "LightTheme/NumericButton/TextTintColor")!
        ),
        actionButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "LightTheme/ActionButton/FrameColor")!,
            frameTint:  UIColor(named: "LightTheme/ActionButton/FrameColor")!.darker(by: 0.5),
            textColor:  UIColor(named: "LightTheme/ActionButton/TextColor")!,
            textTint:   UIColor(named: "LightTheme/ActionButton/TextTintColor")!
        ),
        miscButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "LightTheme/MiscButton/FrameColor")!,
            frameTint:  UIColor(named: "LightTheme/MiscButton/FrameColor")!.darker(by: 0.5),
            textColor:  UIColor(named: "LightTheme/MiscButton/TextColor")!,
            textTint:   UIColor(named: "LightTheme/MiscButton/TextTintColor")!
        ),
        buttonBorderColor: UIColor(named: "LightTheme/ButtonBorderColor")!,
        bitButtonColor: UIColor(named: "LightTheme/BitButtonColor")!
    )
    
    static let dark: Style = Style(
        backgroundColor: UIColor(named: "DarkTheme/BackgroundColor")!,
        labelTextColor: UIColor(named: "DarkTheme/LabelTextColor")!,
        secondayLabelTextColor: UIColor(named: "DarkTheme/SecondaryLabelTextColor")!,
        tintColor: UIColor(named: "DarkTheme/TintColor")!,
        numericButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "DarkTheme/NumericButton/FrameColor")!,
            frameTint:  UIColor(named: "DarkTheme/NumericButton/FrameColor")!.lighter(by: 0.5),
            textColor:  UIColor(named: "DarkTheme/NumericButton/TextColor")!,
            textTint:   UIColor(named: "DarkTheme/NumericButton/TextTintColor")!
        ),
        actionButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "DarkTheme/ActionButton/FrameColor")!,
            frameTint:  UIColor(named: "DarkTheme/ActionButton/FrameColor")!.lighter(by: 0.25),
            textColor:  UIColor(named: "DarkTheme/ActionButton/TextColor")!,
            textTint:   UIColor(named: "DarkTheme/ActionButton/TextTintColor")!
        ),
        miscButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "DarkTheme/MiscButton/FrameColor")!,
            frameTint:  UIColor(named: "DarkTheme/MiscButton/FrameColor")!.lighter(by: 0.25),
            textColor:  UIColor(named: "DarkTheme/MiscButton/TextColor")!,
            textTint:   UIColor(named: "DarkTheme/MiscButton/TextTintColor")!
        ),
        buttonBorderColor: UIColor(named: "DarkTheme/ButtonBorderColor")!,
        bitButtonColor: UIColor(named: "DarkTheme/BitButtonColor")!
    )
    
    static let oldSchool: Style = Style(
        backgroundColor: UIColor(named: "OldSchoolTheme/BackgroundColor")!,
        labelTextColor: UIColor(named: "OldSchoolTheme/LabelTextColor")!,
        secondayLabelTextColor: UIColor(named: "OldSchoolTheme/SecondaryLabelTextColor")!,
        tintColor: UIColor(named: "OldSchoolTheme/TintColor")!,
        numericButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "OldSchoolTheme/NumericButton/FrameColor")!,
            frameTint:  UIColor(named: "OldSchoolTheme/NumericButton/FrameColor")!.darker(by: 0.5),
            textColor:  UIColor(named: "OldSchoolTheme/NumericButton/TextColor")!,
            textTint:   UIColor(named: "OldSchoolTheme/NumericButton/TextTintColor")!
        ),
        actionButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "OldSchoolTheme/ActionButton/FrameColor")!,
            frameTint:  UIColor(named: "OldSchoolTheme/ActionButton/FrameColor")!.darker(by: 0.5),
            textColor:  UIColor(named: "OldSchoolTheme/ActionButton/TextColor")!,
            textTint:   UIColor(named: "OldSchoolTheme/ActionButton/TextTintColor")!
        ),
        miscButtonStyle: ButtonStyle(
            frameColor: UIColor(named: "OldSchoolTheme/MiscButton/FrameColor")!,
            frameTint:  UIColor(named: "OldSchoolTheme/MiscButton/FrameColor")!.darker(by: 0.5),
            textColor:  UIColor(named: "OldSchoolTheme/MiscButton/TextColor")!,
            textTint:   UIColor(named: "OldSchoolTheme/MiscButton/TextTintColor")!
        ),
        buttonBorderColor: UIColor(named: "OldSchoolTheme/ButtonBorderColor")!,
        bitButtonColor: UIColor(named: "OldSchoolTheme/BitButtonColor")!
    )
}
