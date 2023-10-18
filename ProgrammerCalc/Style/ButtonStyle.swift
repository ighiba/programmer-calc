//
//  ButtonStyle.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 26.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol ButtonStyleProtocol {
    var frameColor: UIColor { get }
    var frameTint: UIColor { get }
    var textColor: UIColor { get }
    var textTint: UIColor { get }
}

class ButtonStyle: ButtonStyleProtocol {
    var frameColor: UIColor
    var frameTint: UIColor
    var textColor: UIColor
    var textTint: UIColor
    
    init(frameColor: UIColor, frameTint: UIColor, textColor: UIColor, textTint: UIColor) {
        self.frameColor = frameColor
        self.frameTint = frameTint
        self.textColor = textColor
        self.textTint = textTint
    }
}
