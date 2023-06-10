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
        let view = CalculatorView()
        let presenter = CalculatorPresenter()
        
        view.output = presenter
        presenter.input = view
        presenter.calculator = Calculator()
        presenter.converter = Converter()
        presenter.storage = CalculatorStorage()
        
        return view
    }
}
