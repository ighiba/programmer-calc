//
//  UIBarButtonItem.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 19.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func changeImage(named imageName: String) {
        self.image = UIImage(named: imageName)
    }
}
