//
//  Style.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

enum StyleType: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case oldschool = "oldscool"
}

protocol StyleProtocol {
    var backgroundColor: UIColor { get set }
    var labelTextColor: UIColor { get set }
    var secondayLabelTextColor:  UIColor { get set }
    var tintColor: UIColor { get set }
    var numericButtonStyle: ButtonStyleProtocol { get set }
    var actionButtonStyle: ButtonStyleProtocol { get set }
    var miscButtonStyle: ButtonStyleProtocol { get set }
    var buttonBorderColor: UIColor { get set }
}

class Style: StyleProtocol {
    var backgroundColor: UIColor 
    var labelTextColor: UIColor
    var secondayLabelTextColor:  UIColor
    var tintColor: UIColor
    var numericButtonStyle: ButtonStyleProtocol
    var actionButtonStyle: ButtonStyleProtocol
    var miscButtonStyle: ButtonStyleProtocol
    var buttonBorderColor: UIColor
    
    
    init( backgroundColor:         UIColor,
          labelTextColor:          UIColor,
          secondayLabelTextColor:  UIColor,
          tintColor:               UIColor,
          numericButtonStyle:      ButtonStyleProtocol,
          actionButtonStyle:       ButtonStyleProtocol,
          miscButtonStyle:         ButtonStyleProtocol,
          buttonBorderColor:       UIColor) {
        
        self.backgroundColor = backgroundColor
        self.labelTextColor = labelTextColor
        self.secondayLabelTextColor = secondayLabelTextColor
        self.tintColor = tintColor
        self.numericButtonStyle = numericButtonStyle
        self.actionButtonStyle = actionButtonStyle
        self.miscButtonStyle = miscButtonStyle
        self.buttonBorderColor = buttonBorderColor
    }
    
    
}
