//
//  WordSizePresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation

protocol WordSizeOutput: AnyObject {
    var updateHandler: (() -> Void)? { get set }
    func updateCheckmarkIndex()
    func didSelectRow(at index: Int)
}

class WordSizePresenter: WordSizeOutput {
    
    // MARK: - Properties
    
    weak var view: WordSizeInput!
    
    var storage: CalculatorStorage!
    var currentWordSize: WordSize!

    var updateHandler: (() -> Void)?
    
    // MARK: - Methods
    
    func updateCheckmarkIndex() {
        view.setCheckmarkedIndex(for: currentWordSize.value.rawValue)
    }
    
    func didSelectRow(at index: Int) {
        if let newValue = WordSizeType(rawValue: index) {
            currentWordSize.value = newValue
            storage.saveData(currentWordSize)
        }
    }
}
