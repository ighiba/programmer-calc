//
//  ConversionModuleAssembly.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class ConversionModuleAssembly {
    class func configureModule(conversionSettingsDidUpdate: (() -> Void)? = nil) -> UIViewController {
        let view = ConversionViewController()
        let presenter = ConversionPresenter(
            conversionSettings: .shared,
            settings: .shared,
            storage: CalculatorStorage(),
            conversionSettingsDidUpdate: conversionSettingsDidUpdate
        )
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
