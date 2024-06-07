//
//  Styled.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

protocol Styled {
    func styleWillUpdate(with style: Style)
}

extension Styled {
    var style: Style { styleManager.currentStyle }
    private var styleManager: StyleManager { StyleManager.shared }

    func updateStyle(for window: UIWindow?) {
        styleManager.updateStyle(for: window)
    }
}
