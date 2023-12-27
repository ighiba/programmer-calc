//
//  StyledTableViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class StyledTableViewController: UITableViewController, Styled {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        styleWillUpdate(with: style)
    }
    
    /// Calls every viewDidLayoutSubviews call with `style` parameter.
    ///
    /// ```
    /// override func styleWillUpdate(with style: Style) {
    ///     super.styleWillUpdate(with: style)
    ///     // Apply style to your views here
    /// }
    ///
    /// ```
    ///
    /// > Warning: Method should be used only with super call
    ///
    /// - Parameters:
    ///     - style: The style object with set of colors for view customization
    func styleWillUpdate(with style: Style) {
        updateStyle(for: view.window)
        navigationController?.navigationBar.tintColor = style.tintColor
    }
}
