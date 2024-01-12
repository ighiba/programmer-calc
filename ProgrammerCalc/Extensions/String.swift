//
//  String.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 30.09.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

extension String {
    
    init(_ decimal: Decimal, radix: Int) {
        var dec = decimal.rounded(.down)

        var str = String()
        while dec > 0 {
            let remainder = dec % Decimal(radix)
            str.insert(contentsOf: "\(remainder)", at: str.startIndex)
            dec = (dec / Decimal(radix)).rounded(.down)
        }
        
        if str.isEmpty {
            str = "0"
        }

        self.init(stringLiteral: str)
    }
    
    func removedAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removedLeadingSpaces() -> String {
        return removedLeading(character: " ")
    }
    
    /// Removes specified leading character until a non-matching character is found and returns a new String.
    func removedLeading(character: Character) -> String {
        return removedLeading(characters: [character])
    }
    
    /// Removes specified leading characters until a non-matching character is found and returns a new String.
    func removedLeading(characters: [Character]) -> String {
        var str = self
        
        while str.count > 0 && characters.contains(str.first!) {
            str.removeFirst()
            guard str != "" else { return str }
        }
        
        return str
    }
    
    func adjusted(toLenght targetLenght: Int, repeatingCharacter character: Character) -> String {
        guard self.count != targetLenght else { return self }
        
        if self.count > targetLenght {
            return contracted(toLenght: targetLenght)
        } else {
            return expanded(toLenght: targetLenght, repeatingCharacter: character)
        }
    }
    
    func contracted(toLenght targetLenght: Int) -> String {
        guard self.count > targetLenght else { return self }
        
        let endIndex = self.index(self.startIndex, offsetBy: targetLenght)
        let range = self.startIndex..<endIndex
        
        return String(self[range])
    }
    
    func expanded(toLenght targetLenght: Int, repeatingCharacter character: Character) -> String {
        guard self.count < targetLenght else { return self }
        
        let needToExpandCount = targetLenght - self.count
        
        return self + String(repeating: character, count: needToExpandCount)
    }
    
    func reversedString() -> String {
        return String(self.reversed())
    }
}

extension String {
    
    enum Partition: Int {
        case before = 0
        case after = 1
    }
    
    func getPart(_ partition: Partition, separator: Character) -> String {
        let components = self.components(separatedBy: "\(separator)")
        
        if components.count > partition.rawValue {
            return components[partition.rawValue]
        } else {
            return ""
        }
    }
}
