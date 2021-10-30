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
    // First section array
    var firstSection: [AppSettingsCell] { get set }
    // Second section array
    var otherSection: [AppSettingsCell] { get set }
    // Open appearance view
    func openAppearance()
    // Open about view
    func openAbout()
}

class SettingsViewController: PCalcTableViewController, SettingsViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties

    // Cels
    // First section array
    var firstSection = [ AppSettingsCell(style: .default,
                                         reuseIdentifier: "appearance",
                                         label: NSLocalizedString("Appearance", comment: ""),
                                         hasSwitcher: false),
                         AppSettingsCell(style: .default,
                                         reuseIdentifier: "tappingSounds",
                                         label:  NSLocalizedString("Tapping sounds", comment: ""),
                                         hasSwitcher: true),
                         AppSettingsCell(style: .default,
                                         reuseIdentifier: "haptic",
                                         label: NSLocalizedString("Haptic feedback", comment: ""),
                                         hasSwitcher: true),]
    // Second section array
    var otherSection = [ AppSettingsCell(style: .default,
                                         reuseIdentifier: "about",
                                         label: NSLocalizedString("About app", comment: ""),
                                         hasSwitcher: false)]
    
    // Views
    lazy var settingsView = SettingsView(frame: CGRect(), style: .grouped)
    lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsViewController.closeButtonTapped))
    
    // links to storages
    private let settingsStorage: SettingsStorageProtocol = SettingsStorage()
    private let styleStorage: StyleStorageProtocol = StyleStorage()
    
    private let styleFactory: StyleFactory = StyleFactory()
    
    // updater settings in PCalcViewController
    var updaterHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.controllerDelegate = self
        self.tableView = settingsView
        
        // Color for done item
        let style = styleFactory.get(style: styleStorage.safeGetStyleData())
        //doneItem.tintColor = style.tintColor
        self.navigationController?.navigationBar.tintColor = style.tintColor
        
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
    }
    
    
    // MARK: - Methods
    
    // Update settings values
    fileprivate func getSettings() {
        // get data from UserDefaults
        let settings = settingsStorage.safeGetData()
        // loop table cells
        DispatchQueue.main.async { [self] in
            // loop table cells in firstSections
            for cell in firstSection {
                // check if cell have switcher
                guard cell.switcher != nil else {
                    continue
                }
                // check cell reuseID
                switch cell.reuseIdentifier {
                case "tappingSounds":
                    cell.switcher?.setOn(settings.tappingSounds, animated: false)
                case "haptic":
                    cell.switcher?.setOn(settings.hapticFeedback, animated: false)
                default:
                    // do nothing
                    break
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
    fileprivate func saveSettings() {
        // set data to UserDefaults
        var newSettings = settingsStorage.safeGetData()
        // loop table cells in firstSections
        for cell in firstSection {
            // check if cell have switcher
            guard cell.switcher != nil else {
                continue
            }
            // check cell reuseID
            switch cell.reuseIdentifier {
            case "tappingSounds":
                newSettings.tappingSounds = cell.switcher!.isOn
            case "haptic":
                newSettings.hapticFeedback = cell.switcher!.isOn
            default:
                // do nothing
                break
            }
        }
        // Apply settings
        settingsStorage.saveData(newSettings)
        
    }
    
    // Appearance cell touch
    func openAppearance() {
        let appearanceVC = AppearanceViewController()
        self.navigationController?.pushViewController(appearanceVC, animated: true)
    }

    // About app cell touch
    func openAbout() {        
        let aboutVC = AboutViewController()
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    // MARK: - Actions
    
    // Close settings popover
    @objc func closeButtonTapped( sender: UIButton) {
        self.dismiss(animated: true, completion: {
            // unlock rotation
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.allButUpsideDown, andRotateTo: UIInterfaceOrientation.portrait)
        })
    }
    
    // Switcher handler
    @objc func switcherToggled( sender: UISwitch) {
        // save settings
        saveSettings()        
    }
    
}


