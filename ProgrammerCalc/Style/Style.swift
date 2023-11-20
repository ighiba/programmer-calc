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
        backgroundColor: UIColor(hex: 0xF8F8F8, alpha: 1),
        labelTextColor: UIColor.black,
        secondayLabelTextColor: UIColor(hex: 0xC4C4C4, alpha: 1),
        tintColor: UIColor.systemBlue,
        numericButtonStyle: ButtonStyle(
            frameColor: UIColor(hex: 0xEBEBEB, alpha: 1),
            frameTint:  UIColor(hex: 0xEBEBEB, alpha: 1).darker(by: 0.5),
            textColor:  UIColor.black,
            textTint:   UIColor.black
        ),
        actionButtonStyle: ButtonStyle(
            frameColor: UIColor.systemOrange,
            frameTint:  UIColor.systemOrange.darker(by: 0.5),
            textColor:  UIColor.white,
            textTint:   UIColor.white
        ),
        miscButtonStyle: ButtonStyle(
            frameColor: UIColor(hex: 0xBDBDBD, alpha: 1),
            frameTint:  UIColor(hex: 0xBDBDBD, alpha: 1).darker(by: 0.5),
            textColor:  UIColor.white,
            textTint:   UIColor.white
        ),
        buttonBorderColor: UIColor(hex: 0xE7E7E7, alpha: 1),
        bitButtonColor: UIColor.black
    )
    
    static let dark: Style = Style(
        backgroundColor: UIColor.black,
        labelTextColor: UIColor.white,
        secondayLabelTextColor: UIColor(hex: 0xC4C4C4, alpha: 1),
        tintColor: UIColor.systemOrange,
        numericButtonStyle: ButtonStyle(
            frameColor: UIColor(hex: 0x474747, alpha: 1),
            frameTint:  UIColor(hex: 0x474747, alpha: 1).lighter(by: 0.5),
            textColor:  UIColor.white,
            textTint:   UIColor.white
        ),
        actionButtonStyle: ButtonStyle(
            frameColor: UIColor.systemOrange,
            frameTint:  UIColor.systemOrange.lighter(by: 0.25),
            textColor:  UIColor.white,
            textTint:   UIColor.white
        ),
        miscButtonStyle: ButtonStyle(
            frameColor: UIColor(hex: 0x929292, alpha: 1),
            frameTint:  UIColor(hex: 0x929292, alpha: 1).lighter(by: 0.25),
            textColor:  UIColor.white,
            textTint:   UIColor.white
        ),
        buttonBorderColor: UIColor.clear,
        bitButtonColor: UIColor.white
    )
    
    static let oldSchool: Style = Style(
        backgroundColor: UIColor(hex: 0x010700, alpha: 1),
        labelTextColor: UIColor(hex: 0x4AF626, alpha: 1), // terminal green
        secondayLabelTextColor: UIColor(hex: 0xC4C4C4, alpha: 1),
        tintColor: UIColor(hex: 0x4AF626, alpha: 1),
        numericButtonStyle: ButtonStyle(
            frameColor: UIColor(hex: 0xD7D8C6, alpha: 1),
            frameTint:  UIColor(hex: 0xD7D8C6, alpha: 1).darker(by: 0.5),
            textColor:  UIColor.black,
            textTint:   UIColor.black
        ),
        actionButtonStyle: ButtonStyle(
            frameColor: UIColor.systemOrange,
            frameTint:  UIColor(hex: 0x474747, alpha: 1).darker(by: 0.5),
            textColor:  UIColor.white,
            textTint:   UIColor.white
        ),
        miscButtonStyle: ButtonStyle(
            frameColor: UIColor(hex: 0x929292, alpha: 1),
            frameTint:  UIColor(hex: 0x929292, alpha: 1).darker(by: 0.5),
            textColor:  UIColor.black,
            textTint:   UIColor.black
        ),
        buttonBorderColor: UIColor.clear,
        bitButtonColor: UIColor.white
    )
}
