//
//  StyledView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class StyledView: UIView, Styled {
    override func layoutSubviews() {
        super.layoutSubviews()
        styleWillUpdate(with: self.style)
    }
    
    /// Calls every layoutSubviews call with `style` parameter.
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
        
    }
}
