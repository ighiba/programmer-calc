//
//  AppSettings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol SettingsProtocol {
    var tappingSounds: Bool { get set }
    var hapticFeedback: Bool { get set }
}

class Settings: SettingsProtocol, Decodable, Encodable {
    var tappingSounds: Bool
    var hapticFeedback: Bool
    
    init( tappingSounds: Bool, hapticFeedback: Bool) {
        self.tappingSounds = tappingSounds
        self.hapticFeedback = hapticFeedback
    }
}


