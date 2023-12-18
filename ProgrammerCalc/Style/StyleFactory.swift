//
//  StyleFactory.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

final class StyleFactory {
    func get(theme: Theme) -> Style {
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .oldschool:
            return .oldSchool
        }
    }
}
