//
//  UIScreen.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

extension UIScreen {
    /// Real screen size, doesn't depends on device orientation
    class func mainRealSize() -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let width = screenWidth < screenHeight ? screenWidth : screenHeight
        let height = screenWidth > screenHeight ? screenWidth : screenHeight
        return CGSize(width: width, height: height)
    }
}
