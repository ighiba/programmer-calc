//
//  Values.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

var modalViewWidthMultiplier: CGFloat {
    return UIDevice.currentDeviceType == .iPad ? 0.5 : 0.9
}

var modalViewWidth: CGFloat {
    return UIScreen.mainRealSize().width * modalViewWidthMultiplier
}