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

    // removing all spaces from string
    func removeAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
