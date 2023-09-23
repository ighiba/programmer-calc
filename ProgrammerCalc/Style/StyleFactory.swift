//
//  StyleFactory.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class StyleFactory {

    func get(style: StyleType) -> Style {
        switch style {
        case .light:
            return Style(
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
            
        case .dark:
            return Style(
                backgroundColor: UIColor.black,
                labelTextColor: UIColor.white,
                secondayLabelTextColor: UIColor(hex: 0xC4C4C4, alpha: 1),
                tintColor: UIColor.systemOrange,
                numericButtonStyle: ButtonStyle(
                    frameColor: UIColor(hex: 0x474747, alpha: 1),
                    frameTint: UIColor(hex: 0x474747, alpha: 1).lighter(by: 0.5),
                    textColor: UIColor.white,
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
            
        case .oldschool:
            return Style(
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
    }
}
