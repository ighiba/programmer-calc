//
//  PreferenceCellModel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

enum PreferenceCellType {
    case switcher
    case button
    case checkmark
    case standart
}

final class PreferenceCellModel {
    var id: String
    var label: String
    var cellType: PreferenceCellType
    var cellIcon: UIImage?
    var state: Bool?
    var stateDidChanged: ((Bool) -> Void)?

    init(
        id: String,
        label: String,
        cellType: PreferenceCellType,
        cellIcon: UIImage? = nil,
        stateChangeHandler: ((Bool) -> Void)? = nil
    ) {
        self.id = id
        self.label = label
        self.cellType = cellType
        self.cellIcon = cellIcon
        self.stateDidChanged = stateChangeHandler
    }
}
