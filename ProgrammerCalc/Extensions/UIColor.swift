//
//  UIColor.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt64, alpha: CGFloat) {
        let r, g, b: CGFloat
        
        r = CGFloat((hex & 0xff0000) >> 16) / 255
        g = CGFloat((hex & 0x00ff00) >> 8) / 255
        b = CGFloat(hex & 0x0000ff) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
    
    func setDarker(by number: CGFloat) -> UIColor {
        let newRed = self.components.red * number
        let newGreen = self.components.green * number
        let newBlue = self.components.blue * number
        let alpha = self.components.alpha
        let newColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
        return newColor
    }
    
    func setLighter(by number: CGFloat) -> UIColor {
        let newRed = min(self.components.red + number, 1.0)
        let newGreen = min(self.components.green + number, 1.0)
        let newBlue = min(self.components.blue + number, 1.0)
        let alpha = self.components.alpha
        let newColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
        return newColor
    }
}

