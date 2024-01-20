//
//  UIScreen.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

extension UIScreen {
    /// Screen size in portrait orientation. Device orientation change doesn't affect it.
    var portraitSize: CGSize {
        let screenWidth = bounds.width
        let screenHeight = bounds.height
        let width = screenWidth < screenHeight ? screenWidth : screenHeight
        let height = screenWidth > screenHeight ? screenWidth : screenHeight
        return CGSize(width: width, height: height)
    }
}
