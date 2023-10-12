//
//  UISwipeGestureRecognizer.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.10.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

extension UISwipeGestureRecognizer {
    convenience init(target: Any?, action: Selector?, direction: UISwipeGestureRecognizer.Direction, cancelsTouchesInView: Bool) {
        self.init(target: target, action: action)
        self.direction = direction
        self.cancelsTouchesInView = cancelsTouchesInView
    }
}
