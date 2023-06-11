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

final class Settings: SettingsProtocol {
    
    static let shared: Settings = Settings(tappingSounds: false, hapticFeedback: false)
    
    var tappingSounds: Bool
    var hapticFeedback: Bool
    
    init( tappingSounds: Bool, hapticFeedback: Bool) {
        self.tappingSounds = tappingSounds
        self.hapticFeedback = hapticFeedback
    }
    
    func setSettings(_ newSettings: SettingsProtocol) {
        self.tappingSounds = newSettings.tappingSounds
        self.hapticFeedback = newSettings.hapticFeedback
    }
    
    func setTappingSounds(state: Bool) {
        self.tappingSounds = state
    }
    
    func setHapticFeedback(state: Bool) {
        self.hapticFeedback = state
    }
}

extension Settings: Storable {
    static var storageKey: String {
        return "appSettings"
    }
    
    static func getDefault() -> Settings {
        return Settings(tappingSounds: false, hapticFeedback: false)
    }
    
    func set(_ data: Settings) {
        self.tappingSounds = data.tappingSounds
        self.hapticFeedback = data.hapticFeedback
    }
}


