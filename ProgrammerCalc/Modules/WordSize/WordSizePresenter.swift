//
//  WordSizePresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol WordSizeInput: AnyObject {
    func setCheckmarkedIndex(for row: Int)
}

protocol WordSizeOutput: AnyObject {
    var updateHandler: (() -> Void)? { get set }
    func obtainCheckmarkIndex()
    func setNewWordSize(by row: Int)
}

class WordSizePresenter: WordSizeOutput {
    
    // MARK: - Properties
    
    weak var view: WordSizeInput!
    
    var storage: CalculatorStorage!
    var wordSize: WordSize!

    var updateHandler: (() -> Void)?
    
    // MARK: - Methods
    
    func obtainCheckmarkIndex() {
        view.setCheckmarkedIndex(for: wordSize.value.rawValue)
    }
    
    func setNewWordSize(by row: Int) {
        let newValue = WordSizeType(rawValue: row)!
        wordSize.setWordSizeValue(newValue)
        storage.saveData(wordSize)
    }
}
