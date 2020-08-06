//
//  SettingsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    lazy var settingsView = SettingsView()
    lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsViewController.closeButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView = settingsView
        // Done button to navigation bar
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = doneItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    // =======
    // Actions
    // =======
    
    // Close settings popover
    @objc func closeButtonTapped( sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Switcher handler
    @objc func switcherToggled( sender: UISwitch) {

        if let cell = sender.superview as? SettingsCell {
            let title = cell.textLabel?.text
            
            switch title {
            case "Dark mode":
                print("Dark mode switch to \(sender.isOn)")
                break
            case "Tapping sounds":
                print("Tapping sounds switch to \(sender.isOn)")
                break
            case "Haptic feedback":
                print("Haptic feedback switch to \(sender.isOn)")
                break
            default:
                // TODO: Handle
                print("error")
            }
        }
        
    }
    
}


