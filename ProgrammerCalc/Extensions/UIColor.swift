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
        return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
    }
    
    func darker(by value: CGFloat) -> UIColor {
        return UIColor(
            red: components.red * value,
            green: components.green * value,
            blue: components.blue * value,
            alpha: components.alpha
        )
    }
    
    func lighter(by value: CGFloat) -> UIColor {
        return UIColor(
            red: min(components.red + value, 1.0),
            green: min(components.green + value, 1.0),
            blue: min(components.blue + value, 1.0),
            alpha: components.alpha
        )
    }
}

extension UIColor {
    static let popoverDoneButtonColor: UIColor = UIColor(named: "PopoverDoneButtonColor")!
    static let popoverDoneButtonColorPressed: UIColor = UIColor(named: "PopoverDoneButtonColorPressed")!
}
