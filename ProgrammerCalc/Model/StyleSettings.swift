//
//  StyleSettings.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 27.01.2022.
//  Copyright © 2022 ighiba. All rights reserved.
//

import Foundation

protocol StyleSettingsProtocol {
    var isUsingSystemStyle: Bool { get set }
    var currentStyle: StyleType { get set}
}

class StyleSettings: StyleSettingsProtocol, Decodable, Encodable {
    // MARK: - Properties
    var isUsingSystemStyle: Bool
    var currentStyle: StyleType
    
    init(isUsingSystemStyle: Bool, currentStyle: StyleType) {
        self.isUsingSystemStyle = isUsingSystemStyle
        self.currentStyle = currentStyle
    }
    
}
