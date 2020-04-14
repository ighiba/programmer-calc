//
//  ViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var buttons: [UIButton] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        let button = CalculatorButton.init(type: .custom)
        button.frame = CGRect( x: 100, y: 100, width: 100.0, height: 100.0)
        button.setTitle("0", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        // set font size, font family
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 45.0)
        // set borders
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(button)
        

    }
    @objc func numButtonAction(sender: UIButton!) {
        print("num button tapped")
    }

    func createButtons() {
        for number  in 1...9 {
            //let button = UIButton.
            //buttons.append(UIButton.)
        }
    }


}

//
// Class for calculator's buttons
//

class CalculatorButton: UIButton {
    // override isHighlighted for calculator buttons
    override open var isHighlighted: Bool {
        // if variable state changed
        // change background color for calulator buttons while they pressed
        didSet {
            if isHighlighted {
                // create button animation when button pressed
                UIView.transition(
                    with: self,
                    duration: 0.1,
                    options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .lightGray },
                    completion: nil)
            } else {
                // create button animation when button unpressed
                UIView.transition(
                    with: self,
                    duration: 0.3,
                    options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                    animations: { self.backgroundColor = .white },
                    completion: nil)
            }  
        }
    }
}


