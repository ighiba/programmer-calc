//
//  SettingsModel.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

class SettingsModel: Codable {
    var darkMode: Bool
    var tappingSounds: Bool
    var hapticFeedback: Bool
    
    init(darkMode: Bool, tappingSounds: Bool, hapticFeedback: Bool) {
        self.darkMode = darkMode
        self.tappingSounds = tappingSounds
        self.hapticFeedback = hapticFeedback
    }
}
