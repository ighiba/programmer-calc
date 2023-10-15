//
//  WordSizeModuleAssembly.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 22.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class WordSizeModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = WordSizeViewController()
        let presenter = WordSizePresenter()
        
        view.output = presenter
        presenter.view = view
        
        presenter.storage = CalculatorStorage()
        presenter.currentWordSize = WordSize.shared
        
        return view
    }
}
