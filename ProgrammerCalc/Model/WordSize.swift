//
//  WordSize.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol WordSizeProtocol {
    var value: Int { get set }
}

final class WordSize: WordSizeProtocol {
    
    static let shared: WordSize = WordSize(64)

    // MARK: - Properties
    
    static let wordsDictionary = [["QWORD":64],
                                ["DWORD":32],
                                ["WORD" :16],
                                ["BYTE" :8]]
    var value: Int
    
    init(_ size: Int) {
        self.value = size
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
        return WordSize(64)
    }
    
    func set(_ data: WordSize) {
        self.value = data.value
    }
}
