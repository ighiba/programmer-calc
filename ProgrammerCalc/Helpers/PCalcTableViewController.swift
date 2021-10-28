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
        // Style storage
        let styleStorage: StyleStorageProtocol = StyleStorage()
        // Style factory
        let styleFactory: StyleFactory = StyleFactory()
        // change navbar tint
        let styleName = styleStorage.safeGetStyleData()
        let style = styleFactory.get(style: styleName)
        self.navigationController?.navigationBar.tintColor = style.tintColor
    }
}
