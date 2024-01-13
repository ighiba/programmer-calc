//
//  OctHexHelper.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

struct OctHexHelper {
    
    enum BitTable {
        case oct
        case hex
        
        fileprivate var bitsInGroup: Int {
            switch self {
            case .oct:
                return 3
            case .hex:
                return 4
            }
        }
        
        fileprivate var conversionDict: [String: String] {
            switch self {
            case .oct:
                return [
                    "000" : "0",
                    "001" : "1",
                    "010" : "2",
                    "011" : "3",
                    "100" : "4",
                    "101" : "5",
                    "110" : "6",
                    "111" : "7"
                ]
            case .hex:
                return [
                    "0000" : "0",
                    "0001" : "1",
                    "0010" : "2",
                    "0011" : "3",
                    "0100" : "4",
                    "0101" : "5",
                    "0110" : "6",
                    "0111" : "7",
                    "1000" : "8",
                    "1001" : "9",
                    "1010" : "A",
                    "1011" : "B",
                    "1100" : "C",
                    "1101" : "D",
                    "1110" : "E",
                    "1111" : "F"
                ]
            }
        }
        
        fileprivate func isValidDigitCharacter(_ digitCharacter: Character) -> Bool {
            switch self {
            case .oct:
                return digitCharacter.isOctDigit
            case .hex:
                return digitCharacter.isHexDigit
            }
        }
    }
    
    private let bitTable: BitTable
    
    init(bitTable: BitTable) {
        self.bitTable = bitTable
    }
    
    // MARK: - Methods
    
    func convertToIntegerDigits(from bits: BitArray) -> DigitArray {
        return convertToDigits(from: bits, inReverseOrder: true, converter: convertIntegerBitsToString)
    }
    
    func convertToFractionalDigits(from bits: BitArray) -> DigitArray {
        return convertToDigits(from: bits, inReverseOrder: false, converter: convertFractionalBitsToString)
    }
    
    private func convertToDigits(from bits: BitArray, inReverseOrder isUsingReverseOrder: Bool, converter: (BitArray) -> String) -> DigitArray {
        var convertedString = converter(bits)
        if isUsingReverseOrder {
            convertedString = convertedString.reversedString()
        }
        
        let digits: [Digit] = convertedString.map { ($0) }
        
        return DigitArray(digits: digits)
    }
    
    func convertIntegerBitsToString(from bitArray: BitArray) -> String {
        return convertBitsToString(bitArray, usingBitTable: bitTable, inReverseOrder: true).reversedString()
    }
    
    func convertFractionalBitsToString(from bitArray: BitArray) -> String {
        return convertBitsToString(bitArray, usingBitTable: bitTable, inReverseOrder: false)
    }
    
    private func convertBitsToString(_ bitArray: BitArray, usingBitTable bitTable: BitTable, inReverseOrder isUsingReverseOrder: Bool) -> String {
        let groupedBits = bitArray.groupedBits(bitsInGroup: bitTable.bitsInGroup)
        var bitStrings = groupedBits.map({ $0.compactMap({ String($0) }).joined() })
        if isUsingReverseOrder {
            bitStrings = bitStrings.map { $0.reversedString() }
        }

        return bitStrings.compactMap({ bitTable.conversionDict[$0] }).reduce("", +)
    }
    
    func parseInputString(_ stringValue: String) -> (intPart: BitArray, fractPart: BitArray)? {
        let isInputStringValid = stringValue.filter({ bitTable.isValidDigitCharacter($0) || $0 == "." }) == stringValue
        guard isInputStringValid else { return nil }
        
        let intPartString = stringValue.getComponent(.before, separator: ".")
        let fractPartString = stringValue.getComponent(.after, separator: ".")
        
        let intPart = convertStringToBits(intPartString, usingBitTable: bitTable)
        let fractPart = convertStringToBits(fractPartString, usingBitTable: bitTable)
        
        return (intPart, fractPart)
    }
    
    private func convertStringToBits(_ stringPartValue: String, usingBitTable bitTable: BitTable) -> BitArray {
        let conversionDict = bitTable.conversionDict.inverted()
        let bitsString = stringPartValue.map({ String($0) }).compactMap({ conversionDict[$0] }).reduce("", +)
        let bits = bitsString.compactMap { Bit($0) }
        
        return BitArray(bits: bits)
    }
    
    func convertDigitToBits(_ digit: Character) -> [Bit] {
        guard bitTable.isValidDigitCharacter(digit) else { return [] }
        
        let conversionDict = bitTable.conversionDict.inverted()
        let bitsString = conversionDict[String(digit)] ?? ""
        let bits = bitsString.compactMap { Bit($0) }
        
        return bits
    }
}

extension [String: String] {
    func inverted() -> [String: String] {
        return self.reduce(into: [:]) { partialResult, tuple in
            let (key, value) = tuple
            partialResult[value] = key
        }
    }
}
