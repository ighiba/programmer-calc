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
    weak var numButtonsView: UICollectionView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        /*
        let button = CalculatorButton.init(type: .custom)
        button.frame = CGRect( x: 90, y: 90, width: 90.0, height: 90.0)
        // set tag for interation
        button.tag = 1
        button.setTitle("0", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        // set font size, font family
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 45.0)
        // set borders
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        // round corners
        button.layer.cornerRadius = 35.0
        self.view.addSubview(button)
        */
        createButtons()
        //self.view.addSubview(createButtons())

    }
    @objc func numButtonAction(sender: UIButton!) {
        print("num button tapped")
    }

    func createButtons()  {
        //===========
        // Properties
        // ==========
        var buttonLabel: Int = 9
        //var buttons: [UIButton] = []
        
        for row in 0...2{
            
            buttonLabel = buttonLabel - 2
            
            for column  in 0...2 {
                
                let button = CalculatorButton.init(type: .custom)
                button.frame = CGRect( x: Double(100*column + 20), y: Double(100*row + 300), width: 90.0, height: 90.0)
                    
                // set tag for interation
                button.tag = buttonLabel
                button.addTarget(self, action: #selector(toucUhpOutsideAction), for: [.touchDragExit, .touchDragOutside])
                button.setTitle(String(buttonLabel), for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
                // set font size, font family
                button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 45.0)
                // set borders
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.lightGray.cgColor
                // round corners
                button.layer.cornerRadius = 35.0
                
                buttonLabel += 1

                self.view.addSubview(button)
            }
            buttonLabel = buttonLabel - 4
        }
        //return buttons
    }
    @objc func toucUhpOutsideAction(sender: UIButton) {
        //print("touchUpOutside")
        //sender.isHighlighted = false
    }


}

//
// Class for calculator's buttons
//

class CalculatorButton: UIButton {
    private let _boundsExtension: CGFloat = 0
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


