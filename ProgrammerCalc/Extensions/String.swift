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
            let reminder = dec % Decimal(radix)
            str.insert(contentsOf: "\(reminder)", at: str.startIndex)
            dec = (dec / Decimal(radix))
            dec = dec.rounded(.down)
        }

        self.init(stringLiteral: str)
    }
    
    func replace(atPosition position: Int, with char: Character) -> String {
        guard position >= 0 && position < self.count else { return self }
        
        var charArray = [Character](self)
        charArray[position] = char
        
        return String(charArray)
    }

    func removedAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func swap(first: Character, second: Character) -> String {
        var resultStr = String()
        
        for char in self {
            switch char {
            case first:
                resultStr.append(second)
            case second:
                resultStr.append(first)
            default:
                resultStr.append(char)
            }
        }
        
        return resultStr
    }
    
    /// Removes leading given chars in str until str.last != character
    func removedLeading(characters: [Character]) -> String {
        var str = self.removedAllSpaces()
        
        while str.count > 0 && characters.contains(str.first!) {
            str.removeFirst()
            guard str != "" else { return str }
        }
        
        return str
    }
    
    /// Removes trailing given chars in str until str.last != character
    func removedTrailing(characters: [Character]) -> String {
        var str = self.removedAllSpaces()
        
        while str.count > 0 && characters.contains(str.last!)  {
            str.removeLast()
            guard str != "" else { return str }
        }
        
        return str
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
