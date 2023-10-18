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
