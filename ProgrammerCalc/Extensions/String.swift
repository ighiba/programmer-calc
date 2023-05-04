//
//  String.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 30.09.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

extension String {
    // convert decimal to binary str
    init(_ valueDec: Decimal, radix: Int) {
        self.init()
        var dec = valueDec
        var decCopy = dec
        // round decimal
        NSDecimalRound(&dec, &decCopy, 0, .down)
        
        var str = String()
        
        while dec > 0 {
            autoreleasepool {
                // get reminder
                let reminder =  dec % Decimal(radix)
                str.append("\(reminder)")
                // divide dec
                dec = dec / Decimal(radix)
                decCopy = dec
                // round dec
                NSDecimalRound(&dec, &decCopy, 0, .down) 
            }
        }
        // reverse string
        self = String(str.reversed())
    }
    
    func replaceAt(index: Int, with char: Character) -> String {
        var charArray = [Character](self)
        charArray[index] = char
        return String(charArray)
    }

    // removing all spaces from string
    func removeAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    // change places of input chars in string
    func swap(first: Character, second: Character) -> String {
        let buffStr = self
        var resultStr = String()
        
        // process each character
        buffStr.forEach { (bit) in
            switch bit {
            case "0":
                resultStr.append("1")
                break
            case "1":
                resultStr.append("0")
                break
            default:
                resultStr.append(bit)
                break
            }
        }
        return resultStr
    }
    
    // removes leading given chars in str until str.last != character
    func removeLeading(characters: [Character]) -> String {
        var str = self.removeAllSpaces()
        while str.count > 0 && characters.contains(str.first!) {
            str.removeFirst(1)
            guard str != "" else {
                return str
            }
        }
        return str
    }
    
    // removes trailing given chars in str until str.last != character
    func removeTrailing(characters: [Character]) -> String {
        var str = self.removeAllSpaces()
        while str.count > 0 && characters.contains(str.last!)  {
            str.removeLast(1)
            guard str != "" else {
                return str
            }
        }
        return str
    }
    
    func getPartAfter(separator: Character) -> String {
        let components = self.components(separatedBy: "\(separator)")
        if components.count <= 1 {
            return ""
        } else {
            return components[1]
        }
    }
    
    func getPartBefore(separator: Character) -> String {
        let components = self.components(separatedBy: "\(separator)")
        if components.count == 0 {
            return ""
        } else {
            return components[0]
        }
    }
 
}
