//
//  BinaryMath.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

extension CalcMath {
    
    public func addBinary(_ firstValue: String, _ secondValue: String) -> String {
        var resultStr = String()
        
        // TODO: Check for binary
        
        // Make values equal (by lenght)
        let equaled = numberOfDigitsEqual(firstValue: firstValue, secondValue: secondValue)
        
        var firstBinary = equaled.0
        var secondBinary = equaled.1
        
        // Do addition
        var reminder = 0
        
        while firstBinary != "" {
            
            let firstLast = String(firstBinary.last!)
            let secondLast = String(secondBinary.last!)
            
            // if point then new iteration
            guard firstLast != "." && secondLast != "." else {
                resultStr = "." + resultStr
                firstBinary.removeLast()
                secondBinary.removeLast()
                continue
            }
            
            let intBuff = Int(firstLast)! + Int(secondLast)! + reminder
            
            switch intBuff {
            case 0:
                resultStr = "0" + resultStr
                break
            case 1:
                resultStr = "1" + resultStr
                reminder = 0
                break
            case 2:
                resultStr = "0" + resultStr
                reminder = 1
                break
            case 3:
                resultStr = "1" + resultStr
                reminder = 1
            default:
                break
            }
            
            firstBinary.removeLast()
            secondBinary.removeLast()
        }
        
        // add last reminder if not 0
        if reminder == 1 {
            resultStr = "1" + resultStr
        }

        return resultStr
    }
    
    // inverting value 1 -> 0; 0 -> 1
    static func inverBinary(binary: String) -> String {
        var resultStr = String()
        
        binary.forEach { (num) in
            switch num {
            case "0":
                resultStr.append("1")
            case "1":
                resultStr.append("0")
            default:
                resultStr.append(num)
                break
            }
        }
        
        return resultStr
    }
    
}
