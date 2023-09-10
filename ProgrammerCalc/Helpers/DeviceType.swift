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
    static var currentDeviceType: DeviceType {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return .iPad
        default:
            return .iPhone
        }
    }
}
