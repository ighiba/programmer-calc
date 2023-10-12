//
//  UITapGestureRecognizer.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.10.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    convenience init(target: Any?, action: Selector?, numberOfTapsRequired: Int = 1, cancelsTouchesInView: Bool) {
        self.init(target: target, action: action)
        self.numberOfTapsRequired = numberOfTapsRequired
        self.cancelsTouchesInView = cancelsTouchesInView
    }
}
