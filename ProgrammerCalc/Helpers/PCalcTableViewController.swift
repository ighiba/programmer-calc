//
//  PCalcTableViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 27.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class PCalcTableViewController: UITableViewController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Style factory
        let styleFactory: StyleFactory = StyleFactory()
        // change navbar tint
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        self.navigationController?.navigationBar.tintColor = style.tintColor
    }
}
