//
//  SettingsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import MessageUI

protocol SettingsViewControllerDelegate: AnyObject {
    // First section array
    var firstSection: [SettingsCell] { get set }
    // Second section array
    var otherSection: [SettingsCell] { get set }
    // Open appearance view
    func openAppearance()
    // Open about view
    func openAbout()
}

class SettingsViewController: PCalcTableViewController, SettingsViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties

    // Cels
    // First section array
    var firstSection = [ SettingsCell(style: .default,
                                         reuseIdentifier: "appearance",
                                         label: NSLocalizedString("Appearance", comment: ""),
                                         hasSwitcher: false),
                         SettingsCell(style: .default,
                                         reuseIdentifier: "tappingSounds",
                                         label:  NSLocalizedString("Tapping sounds", comment: ""),
                                         hasSwitcher: true),
                         SettingsCell(style: .default,
                                         reuseIdentifier: "haptic",
                                         label: NSLocalizedString("Haptic feedback", comment: ""),
                                         hasSwitcher: true),]
    // Second section array
    var otherSection = [ SettingsCell(style: .default,
                                         reuseIdentifier: "about",
                                         label: NSLocalizedString("About app", comment: ""),
                                         hasSwitcher: false)]
    
    // Views
    lazy var settingsView = SettingsView(frame: CGRect(), style: .insetGrouped)
    lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsViewController.closeButtonTapped))
    
    // Storage
    private let storage = CalculatorStorage()
    
    private let styleFactory: StyleFactory = StyleFactory()
    
    private let settings: Settings = Settings.shared
    
    // updater settings in PCalcViewController
    var updaterHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.controllerDelegate = self
        self.tableView = settingsView
        
        // Color for done item
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        self.navigationController?.navigationBar.tintColor = style.tintColor
        
        // Setup navigation items
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = doneItem
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Settings", comment: "")
        
        self.tableView.reloadData()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
        // get switch last state from UserDefaults
        getSettings()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save switch state to UserDefaults
        saveSettings()
        // update settings in PCalcViewController
        updaterHandler?()
    }
    
    
    // MARK: - Methods
    
    // Update settings values
    fileprivate func getSettings() {
        // get data from UserDefaults
        let loadedSettings: Settings = storage.loadData()
        settings.setSettings(loadedSettings)
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
                default: break
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
    fileprivate func saveSettings() {
        // loop table cells in firstSections
        for cell in firstSection {
            // check if cell have switcher
            guard cell.switcher != nil else {
                continue
            }
            // check cell reuseID
            switch cell.reuseIdentifier {
            case "tappingSounds":
                settings.tappingSounds = cell.switcher!.isOn
            case "haptic":
                settings.hapticFeedback = cell.switcher!.isOn
            default: break
            }
        }
        // Apply settings to UserDefaults
        storage.saveData(settings)
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
            AppDelegate.AppUtility.unlockPortraitOrientation()
        })
    }
    
    // Switcher handler
    @objc func switcherToggled( sender: UISwitch) {
        saveSettings()        
    }
    
}


