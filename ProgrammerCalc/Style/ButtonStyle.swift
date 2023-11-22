//
//  ButtonStyle.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 26.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol ButtonStyleProtocol {
    var backgroundColor: UIColor { get }
    var backgroundTintColor: UIColor { get }
    var textColor: UIColor { get }
    var textTintColor: UIColor { get }
}

class ButtonStyle: ButtonStyleProtocol {
    var backgroundColor: UIColor
    var backgroundTintColor: UIColor
    var textColor: UIColor  
    var textTintColor: UIColor
    
    init(backgroundColor: UIColor, backgroundTintColor: UIColor, textColor: UIColor, textTintColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.backgroundTintColor = backgroundTintColor
        self.textColor = textColor
        self.textTintColor = textTintColor
    }
}
