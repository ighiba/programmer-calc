//
//  UIApplication.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

extension UIApplication {
    static var appVersion: String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String }
    static var buildNumber: String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String }
}
