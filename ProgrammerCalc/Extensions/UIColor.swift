//
//  UIColor.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat) {
        let r, g, b: CGFloat
        
        r = CGFloat((hex & 0xff0000) >> 16) / 255
        g = CGFloat((hex & 0x00ff00) >> 8) / 255
        b = CGFloat(hex & 0x0000ff) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    var ciColor: CIColor { CIColor(color: self) }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = ciColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
    
    func darker(by number: CGFloat) -> UIColor {
        let newRed = components.red * number
        let newGreen = components.green * number
        let newBlue = components.blue * number
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: components.alpha)
    }
    
    func lighter(by number: CGFloat) -> UIColor {
        let newRed = min(components.red + number, 1.0)
        let newGreen = min(components.green + number, 1.0)
        let newBlue = min(components.blue + number, 1.0)
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: components.alpha)
    }
}
