//
//  Array.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 04.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

extension Array {
    func adjusted(toCount targetCount: Int, repeatingElement element: Element) -> Self {
        guard self.count != targetCount else { return self }
        
        if self.count > targetCount {
            return contracted(toCount: targetCount)
        } else {
            return expanded(toCount: targetCount, repeatingElement: element)
        }
    }
    
    func contracted(toCount targetCount: Int) -> Self {
        guard self.count > targetCount else { return self }

        let range = 0..<targetCount
        
        return Self(self[range])
    }

    func expanded(toCount targetCount: Int, repeatingElement element: Element) -> Self {
        guard self.count < targetCount else { return self }
        
        let needToExpandCount = targetCount - self.count
        
        return self + Self(repeating: element, count: needToExpandCount)
    }
}
