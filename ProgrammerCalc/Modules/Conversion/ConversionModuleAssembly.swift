//
//  ConversionModuleAssembly.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class ConversionModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = ConversionViewController()
        let presenter = ConversionPresenter()
        
        view.output = presenter
        presenter.view = view
        
        presenter.storage = CalculatorStorage()
        presenter.conversionSettings = ConversionSettings.shared
        presenter.settings = Settings.shared
        
        return view
    }
}
