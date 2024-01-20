//
//  DeviceType.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 10.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

enum DeviceType {
    case iPhone
    case iPad
}

extension UIDevice {
    var deviceType: DeviceType {
        switch self.userInterfaceIdiom {
        case .pad:
            return .iPad
        default:
            return .iPhone
        }
    }
}
