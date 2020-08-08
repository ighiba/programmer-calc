//
//  SettingsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    lazy var settingsView = SettingsView(frame: CGRect(), style: .grouped)
    lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsViewController.closeButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = settingsView
        // Setup navigation items
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = doneItem
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        
        self.tableView.reloadData()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get switch last state from UserDefaults
        getSettings()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // save switch state to UserDefaults
        saveSettings()
    }
    
    // =======
    // Methods
    // =======
    
    // Update settings values
    fileprivate func getSettings() {
        // get data from UserDefaults
        if let settings = SavedData.appSettings {
            // loop table cells
            for cell in self.tableView.visibleCells as! [SettingsCell] {
                if let switcher = cell.accessoryView as? UISwitch {
                    let title = cell.textLabel?.text
                    
                    // set switcher to userdefault state
                    switch title {
                    case "Dark mode":
                        switcher.setOn(settings.darkMode, animated: false)
                        break
                    case "Tapping sounds":
                        switcher.setOn(settings.tappingSounds, animated: false)
                        break
                    case "Haptic feedback":
                        switcher.setOn(settings.hapticFeedback, animated: false)
                        break
                    default:
                        // TODO: Handle
                        print("error")
                    }
                }
            }
        } else {
            print("no settings")
            // Save default settings (all true)
            SavedData.appSettings = SettingsModel(darkMode: true, tappingSounds: true, hapticFeedback: true)
        }
    }
    
    fileprivate func saveSettings() {
        // set data to UserDefaults
        if let settings = SavedData.appSettings {
            // loop table cells
            for cell in self.tableView.visibleCells as! [SettingsCell] {
                if let switcher = cell.accessoryView as? UISwitch {
                    let title = cell.textLabel?.text
                    
                    // get from switcher state and set to local userdefaults
                    switch title {
                    case "Dark mode":
                        settings.darkMode = switcher.isOn
                        break
                    case "Tapping sounds":
                        settings.tappingSounds = switcher.isOn
                        break
                    case "Haptic feedback":
                        settings.hapticFeedback = switcher.isOn
                        break
                    default:
                        // TODO: Handle
                        print("error")
                    }
                }
            }
            // Apply settings
            SavedData.appSettings = SettingsModel(darkMode: settings.darkMode, tappingSounds: settings.tappingSounds, hapticFeedback: settings.hapticFeedback)
            
        } else {
            print("no settings")
            // Save default settings (all true)
            SavedData.appSettings = SettingsModel(darkMode: true, tappingSounds: true, hapticFeedback: true)
        }
        
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


