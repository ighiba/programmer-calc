//
//  CalcButtonsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class CalcButtonsViewController: UIViewController {
    
    init( buttonsPage: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.view = buttonsPage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // root vc for handling tappging on PCalcViewController
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? PCalcViewController
        guard rootVC != nil else {
            return
        }
        
        rootVC?.unhighlightLabels()
        
        print("touched began page out")
    }
}
