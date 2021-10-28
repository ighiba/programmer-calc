//
//  ButtonStyle.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 26.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol ButtonStyleProtocol {
    var frameColor: UIColor { get set }
    var frameTint: UIColor { get set }
    var textColor: UIColor { get set }
    var textTint: UIColor { get set }
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
