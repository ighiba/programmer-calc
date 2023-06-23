//
//  AppearanceModuleAssembly.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class AppearanceModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = AppearanceViewController()
        let presenter = AppearancePresenter()
        
        view.output = presenter
        presenter.view = view
        
        presenter.storage = CalculatorStorage()
        presenter.styleFactory = StyleFactory()
        presenter.styleSettings = StyleSettings.shared
        
        return view
    }
}
