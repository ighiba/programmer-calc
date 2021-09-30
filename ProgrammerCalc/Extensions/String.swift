//
//  String.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 30.09.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

extension String {
    // removing all spaces from string
    func removeAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
