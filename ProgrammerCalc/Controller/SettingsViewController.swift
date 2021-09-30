//
//  SettingsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // ==================
    // MARK: - Properties
    // ==================

    lazy var settingsView = SettingsView(frame: CGRect(), style: .grouped)
    lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsViewController.closeButtonTapped))
    
    // links to storages
    private var settingsStorage: SettingsStorageProtocol = SettingsStorage()
    
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
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Update settings values
    fileprivate func getSettings() {
        // get data from UserDefaults
        if let settings = settingsStorage.loadData() {
            // loop table cells
            for cell in self.tableView.visibleCells as! [SettingsCell] {
                if let switcher = cell.accessoryView as? UISwitch {
                    let title = cell.textLabel?.text
                    
                    // set switcher to userdefault state
                    switch title {
                    case "Dark mode":
                        switcher.setOn(settings.darkMode, animated: false)
                    case "Tapping sounds":
                        switcher.setOn(settings.tappingSounds, animated: false)
                    case "Haptic feedback":
                        switcher.setOn(settings.hapticFeedback, animated: false)
                    default:
                        // TODO: Handle
                        print("error")
                        break
                    }
                }
            }
        } else {
            print("no settings")
            // Save default settings (all false)
            let newSettings = Settings(darkMode: false, tappingSounds: false, hapticFeedback: false)
            settingsStorage.saveData(newSettings)
        }
    }
    
    fileprivate func saveSettings() {
        // set data to UserDefaults
        if let settings = settingsStorage.loadData() {
            var newSettings = settings
            // loop table cells
            for cell in self.tableView.visibleCells as! [SettingsCell] {
                if let switcher = cell.accessoryView as? UISwitch {
                    let title = cell.textLabel?.text
                    
                    // get from switcher state and set to local userdefaults
                    switch title {
                    case "Dark mode":
                        newSettings.darkMode = switcher.isOn
                    case "Tapping sounds":
                        newSettings.tappingSounds = switcher.isOn
                    case "Haptic feedback":
                        newSettings.hapticFeedback = switcher.isOn
                    default:
                        // TODO: Handle
                        print("error")
                        break
                    }
                }
            }
            // Apply settings
            settingsStorage.saveData(newSettings)
            
        } else {
            print("no settings")
            // Save default settings (all true)
            let newSettings = Settings(darkMode: true, tappingSounds: true, hapticFeedback: true)
            settingsStorage.saveData(newSettings)
        }
        
    }
    
    // ===============
    // MARK: - Actions
    // ===============
    
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
            case "Tapping sounds":
                print("Tapping sounds switch to \(sender.isOn)")
            case "Haptic feedback":
                print("Haptic feedback switch to \(sender.isOn)")
            default:
                // TODO: Handle
                print("error")
                break
            }
        }
        
    }
    
}


