//
//  Array.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

extension Array {
    func contracted(toCount targetCount: Int) -> Self {
        guard self.count > targetCount else { return self }

        let range = 0..<targetCount
        
        return Self(self[range])
    }
}
