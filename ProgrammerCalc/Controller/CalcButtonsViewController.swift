//
//  CalcButtonsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 28.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class CalcButtonsViewController: UIViewController {
    
    init( buttonsStack: UIView) {
        super.init(nibName: nil, bundle: nil)
        if let stack = buttonsStack as? CalcButtonsMain {
            self.view.backgroundColor = .purple
            self.view = buttonsStack
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideButton))
            tap.numberOfTapsRequired = 1
            self.view.isUserInteractionEnabled = true
            self.view.addGestureRecognizer(tap)
            
        } else {
            self.view.backgroundColor = .red
        }
        let someButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        //someButton.setTitle("sdsdsd", for: .normal)
        //someButton.backgroundColor = .red
        
        self.view.addSubview(someButton)
        
        
    }
    
    
    @objc func tappedOutsideButton( touch: UITouch) {
        let currentLocation: CGPoint = touch.location(in: self.view.subviews[0].subviews[0].subviews[3])
        //let containerBounds: CGRect = conv.container.bounds
        //let inContainer: Bool = containerBounds.contains(currentLocation)
        print(self.view.subviews[0].subviews[0].subviews[3])
        print(currentLocation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
