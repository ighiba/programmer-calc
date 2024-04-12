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
        let conversionSettings = ConversionSettings.shared
        let settings = Settings.shared
        let storage = CalculatorStorage()
        
        let presenter = ConversionPresenter(conversionSettings: conversionSettings, settings: settings, storage: storage)
        let view = ConversionViewController()
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
