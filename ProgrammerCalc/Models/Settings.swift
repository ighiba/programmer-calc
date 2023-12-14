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
    
    static let shared: Settings = Settings()
    
    var tappingSounds: Bool
    var hapticFeedback: Bool
    
    init(tappingSounds: Bool = false, hapticFeedback: Bool = false) {
        self.tappingSounds = tappingSounds
        self.hapticFeedback = hapticFeedback
    }
    
    func setTappingSounds(state: Bool) {
        tappingSounds = state
    }
    
    func setHapticFeedback(state: Bool) {
        hapticFeedback = state
    }
}

extension Settings: Storable {
    
    static var storageKey: String { "appSettings" }
    
    static func getDefault() -> Settings {
        return Settings()
    }
    
    func set(_ data: Settings) {
        tappingSounds = data.tappingSounds
        hapticFeedback = data.hapticFeedback
    }
}
