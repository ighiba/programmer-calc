//
//  UInt8.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

extension UInt8 {
    init?(_ character: Character) {
        self.init(String(character))
    }
}
