//
//  Settings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

protocol SettingsProtocol {
    var isTappingSoundsEnabled: Bool { get set }
    var isHapticFeedbackEnabled: Bool { get set }
}

final class Settings: SettingsProtocol {
    
    static let shared: Settings = Settings()
    
    var isTappingSoundsEnabled: Bool
    var isHapticFeedbackEnabled: Bool
    
    init(isTappingSoundsEnabled: Bool = false, isHapticFeedbackEnabled: Bool = false) {
        self.isTappingSoundsEnabled = isTappingSoundsEnabled
        self.isHapticFeedbackEnabled = isHapticFeedbackEnabled
    }
}

extension Settings: Storable {
    
    static var storageKey: String { "appSettings" }
    
    static func getDefault() -> Settings {
        return Settings()
    }
    
    func set(_ data: Settings) {
        isTappingSoundsEnabled = data.isTappingSoundsEnabled
        isHapticFeedbackEnabled = data.isHapticFeedbackEnabled
    }
}
