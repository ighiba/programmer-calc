//
//  PreferenceCellModel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

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
    var state: Bool?
    var stateDidChanged: ((Bool) -> Void)?
    var systemImageName: String?
    
    init(id: String,
         label: String,
         cellType: PreferenceCellType,
         systemImageName: String? = nil,
         stateDidChanged: ((Bool) -> Void)? = nil) {
        self.id = id
        self.label = label
        self.cellType = cellType
        self.systemImageName = systemImageName
        self.stateDidChanged = stateDidChanged
    }
}
