//
//  CalculatorPresenterMock.swift
//  ProgrammerCalcTests
//
//  Created by Ivan Ghiba on 05.12.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import Foundation
@testable import ProgrammerCalc

class CalculatorPresenterMock: CalculatorPresenterDelegate {
    
    var inputText: String = ""
    var outputText: String = ""

    func setInputLabelText(_ text: String) {
        inputText = text
    }
    
    func setOutputLabelText(_ text: String) {
        outputText = text
    }
}
