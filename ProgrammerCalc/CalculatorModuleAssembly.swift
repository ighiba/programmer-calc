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

        // Layout choice for device type
        switch UIDevice.currentDeviceType {
        case .iPhone:
            view.buttonsContainerController =  ButtonsViewControllerPhone()
        case .iPad:
            view.buttonsContainerController =  ButtonsViewControllerPad()
        }

        view.output = presenter
        presenter.input = view
        presenter.calculator = Calculator()
        presenter.converter = Converter()
        presenter.storage = CalculatorStorage()
        
        return view
    }
}
