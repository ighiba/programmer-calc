//
//  SettingsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import MessageUI

protocol SettingsViewControllerDelegate {
    func openAbout()
}

class SettingsViewController: UITableViewController, SettingsViewControllerDelegate {
    
    // MARK: - Properties

    lazy var settingsView = SettingsView(frame: CGRect(), style: .grouped)
    lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsViewController.closeButtonTapped))
    
    // links to storages
    private var settingsStorage: SettingsStorageProtocol = SettingsStorage()
    
    // updater settings in PCalcViewController
    var updaterHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.controllerDelegate = self
        self.tableView = settingsView
        // Setup navigation items
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = doneItem
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Settings", comment: "")
        
        self.tableView.reloadData()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // lock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        // get switch last state from UserDefaults
        getSettings()
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save switch state to UserDefaults
        saveSettings()
        // update settings in PCalcVC
        updaterHandler?()
        // unlock rotation
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    
    // MARK: - Methods
    
    // Update settings values
    fileprivate func getSettings() {
        // get data from UserDefaults
        let settings = settingsStorage.safeGetData()
        // loop table cells
        DispatchQueue.main.async {
            for cell in self.tableView.visibleCells as! [AppSettingsCell] {
                if let switcher = cell.accessoryView as? UISwitch {
                    let title = cell.textLabel?.text
                    
                    // set switcher to userdefault state
                    switch title {
                    case NSLocalizedString("Appearance", comment: ""):
                        switcher.setOn(settings.darkMode, animated: false)
                    case NSLocalizedString("Tapping sounds", comment: ""):
                        switcher.setOn(settings.tappingSounds, animated: false)
                    case NSLocalizedString("Haptic feedback", comment: ""):
                        switcher.setOn(settings.hapticFeedback, animated: false)
                    default:
                        // TODO: Handle
                        print("error")
                        break
                    }
                }
            }
        }
    }
    
    fileprivate func saveSettings() {
        // set data to UserDefaults
        if let settings = settingsStorage.loadData() {
            var newSettings = settings
            // loop table cells
            for cell in self.tableView.visibleCells as! [AppSettingsCell] {
                if let switcher = cell.accessoryView as? UISwitch {
                    let title = cell.textLabel?.text
                    
                    // get from switcher state and set to local userdefaults
                    switch title {
                    case NSLocalizedString("Appearance", comment: ""):
                        newSettings.darkMode = switcher.isOn
                    case NSLocalizedString("Tapping sounds", comment: ""):
                        newSettings.tappingSounds = switcher.isOn
                    case NSLocalizedString("Haptic feedback", comment: ""):
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
            let newSettings = AppSettings(darkMode: true, tappingSounds: true, hapticFeedback: true)
            settingsStorage.saveData(newSettings)
        }
        
    }

    // About app cell touch
    func openAbout() {        
        let aboutVC = AboutViewController()

        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    // MARK: - Actions
    
    // Close settings popover
    @objc func closeButtonTapped( sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Switcher handler
    @objc func switcherToggled( sender: UISwitch) {
        if let cell = sender.superview as? AppSettingsCell {
            let title = cell.textLabel?.text
            switch title {
            case NSLocalizedString("Appearance", comment: ""):
                print("Appearance switch to \(sender.isOn)")
            case NSLocalizedString("Tapping sounds", comment: ""):
                print("Tapping sounds switch to \(sender.isOn)")
            case NSLocalizedString("Haptic feedback", comment: ""):
                print("Haptic feedback switch to \(sender.isOn)")
            default:
                // TODO: Handle
                print("error")
                break
            }
        }
        
    }
    
}


