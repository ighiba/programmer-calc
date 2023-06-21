//
//  WordSize.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

enum WordSizeType: Int, Codable, CaseIterable {
    case qword = 64
    case dword = 32
    case word  = 16
    case byte  = 8
    
    var title: String {
        switch self {
        case .qword: return "QWORD"
        case .dword: return "DWORD"
        case .word: return "WORD"
        case .byte: return "BYTE"
        }
    }
}

protocol WordSizeProtocol {
    var value: WordSizeType { get set }
    var intValue: Int { get }
}

final class WordSize: WordSizeProtocol {

    static let shared: WordSize = WordSize(.qword)

    // MARK: - Properties

    var value: WordSizeType
    var intValue: Int {
        return value.rawValue
    }
    
    init(_ wordSizeType: WordSizeType) {
        self.value = wordSizeType
    }
    
    func setWordSizeValue(_ newValue: WordSizeType) {
        self.value = newValue
    }
    
    func setWordSize(_ newWordSize: WordSizeProtocol) {
        self.value = newWordSize.value
    }
}

extension WordSize: Storable {
    static var storageKey: String {
        return "wordSize"
    }
    
    static func getDefault() -> WordSize {
        return WordSize(.qword)
    }
    
    func set(_ data: WordSize) {
        self.value = data.value
    }
}
