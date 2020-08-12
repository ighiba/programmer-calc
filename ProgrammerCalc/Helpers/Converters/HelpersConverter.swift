//
//  HelpersConverter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 11.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import Foundation

extension MainConverter {
    // Divide number by parts
    func divideStr( str: String, by partition: Int) -> String {
        var resultStr = str
        var buffStr = String()

        // if count of digits more than or equal to 1 AND number not 0
        if str.count >= 1 && str != "0" {
            var counter: Int = 0
       
            for char in resultStr {
                // check if already point
                if char == "." {
                    counter = 0
                    buffStr.append(char)
                    continue
                }
                // if ok
                if counter == partition-1 {
                    buffStr.append("\(char) ")
                    counter = 0
                } else {
                    buffStr.append(char)
                    counter += 1
                }
            }
            
            // add zeros after for filling the parts
            if counter > 0 {
                for _ in 0...partition-counter-1 {
                    buffStr.append("0")
                }
            }
            
            // delete space before and after .
            if buffStr.contains(".") {
                var pointPos = buffStr.firstIndex(of: ".")!
                
                var pointBuff = buffStr.index(before: pointPos)
                
                // delete space before if exists
                if buffStr[pointBuff] == " " {
                    buffStr.remove(at: pointBuff)
                }
                
                // if . isn't last element
                if buffStr.last != "." {
                    // update indexes
                    pointPos = buffStr.firstIndex(of: ".")!
                    pointBuff = buffStr.index(after: pointPos)
                        // delete space after if exists
                    if buffStr[pointBuff] == " " {
                        buffStr.remove(at: pointBuff)
                    }
                }
            }
            resultStr = buffStr
        }
        
        // remove first and last spaces
        if resultStr.first == " " {
            resultStr.removeFirst()
        }
        if resultStr.last == " " {
            resultStr.removeLast()
        }
        
        return resultStr
    }
    
    // remove all spaces
    func removeAllSpaces(str: String) -> String{
        var buffStr = ""
        str.forEach { (char) in
            // if char != space then ok
            if char != " " {
                buffStr.append(char)
            }
        }
        return buffStr
    }
    
    // filling up number with zeros by num of zeros in 1 part
    func fillUpParts(by fillNum: Int , _ str: String) -> String {
        // remove spaces
        var buffStr = removeAllSpaces(str: str)
        
        if Int(str) != 0 {
            // remove all zeros at beginning of string
            while buffStr.first == "0" {
                buffStr.removeFirst(1)
            }
        } else {
            // if zero then return fillNum zeros
            buffStr = ""
            for _ in 1...fillNum {
                buffStr.append("0")
            }
            
            return buffStr
        }
        
        var counter = 0
        // count how much 0 is need for filling
        buffStr.forEach({ (num) in
            if counter == fillNum - 1 {
                    counter = 0
                } else {
                    counter += 1
                }
            })
        
        // add zeros after for filling the parts
        if counter > 0 {
            for _ in 0...fillNum-counter-1 {
                buffStr = "0" + buffStr
            }
        }

        return buffStr
    }
}
