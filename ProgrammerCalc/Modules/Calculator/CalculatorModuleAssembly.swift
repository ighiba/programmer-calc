//
//  CalculatorModuleAssembly.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 09.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class CalculatorModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = CalculatorViewController()
        let presenter = CalculatorPresenter()

        // Layout choice for device type
        switch UIDevice.current.deviceType {
        case .iPhone:
            view.buttonsContainerController = ButtonsViewControllerPhone()
        case .iPad:
            view.buttonsContainerController = ButtonsViewControllerPad()
        }
        
        let wordSize = WordSize.shared
        let calculatorState = CalculatorState.shared
        let conversionSettings = ConversionSettings.shared
        
        view.output = presenter
        presenter.input = view
        presenter.wordSize = wordSize
        presenter.calculatorState = calculatorState
        presenter.conversionSettings = conversionSettings
        
        let calculator = CalculatorImpl(wordSize: wordSize, calculatorState: calculatorState, conversionSettings: conversionSettings)
        presenter.calculator = calculator
        calculator.calculatorPresenterDelegate = presenter
        
        return view
    }
}
