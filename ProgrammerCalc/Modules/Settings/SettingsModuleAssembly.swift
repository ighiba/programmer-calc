//
//  SettingsModuleAssembly.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class SettingsModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter()
        
        view.output = presenter
        presenter.view = view
        
        presenter.storage = CalculatorStorage()
        presenter.settings = Settings.shared
        
        return view
    }
}
