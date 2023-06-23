//
//  StyledViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 27.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class StyledViewController: UIViewController, Styled {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styleWillUpdate(with: self.style)
    }
    
    /// Calls every viewDidLayoutSubviews  call with `style` parameter.
    ///
    /// ```
    /// override func styleWillUpdate(with style: Style) {
    ///     super.styleWillUpdate(with: style)
    ///     // Apply style to yout views here
    /// }
    ///
    /// ```
    ///
    /// > Warning: Method should be used only with super call
    ///
    /// - Parameters:
    ///     - style: The style object with set of colors for view customization
    func styleWillUpdate(with style: Style) {
        self.updateStyle(for: self.view.window)
        self.navigationController?.navigationBar.tintColor = style.tintColor
    }
}
