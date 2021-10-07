//
//  WordSize.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import Foundation

protocol WordSizeProtocol {
    var wordSize: Int { get set }
}

class WordSize: WordSizeProtocol, Decodable, Encodable  {
    // TOOD: Move somewhere else
    var wordsDictionary = [["QWORD":64],
                           ["DWORD":32],
                           ["WORD" :16],
                           ["BYTE" :8]]
    var wordSize: Int
    
    init(_ size: Int) {
        self.wordSize = size
    }
}
