//
//  AboutModuleAssembly.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class AboutModuleAssembly {
    class func conigureModule() -> UIViewController {
        let view = AboutViewController()
        let presenter = AboutPresenter()
        
        view.output = presenter
        presenter.view = view
        
        presenter.styleFactory = StyleFactory()
        presenter.styleSettings = StyleSettings.shared
        
        return view
    }
}

