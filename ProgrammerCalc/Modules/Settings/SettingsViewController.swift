//
//  SettingsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import MessageUI

fileprivate let tappingSoundsId = "tappingSounds"
fileprivate let hapticFeedbackId = "hapticFeedback"

class SettingsViewController: StyledTableViewController, SettingsInput, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    var output: SettingsOutput!

    lazy var doneItem = UIBarButtonItem(barButtonSystemItem: .done,
                                      target: self,
                                      action: #selector(SettingsViewController.closeButtonTapped))
    
    lazy var preferenceList = [
        [
            PreferenceCellModel(
                id: "appearance",
                label: NSLocalizedString("Appearance", comment: ""),
                cellType: .button
            ),
            PreferenceCellModel(
                id: tappingSoundsId,
                label:  NSLocalizedString("Tapping sounds", comment: ""),
                cellType: .switcher,
                stateDidChanged: tappingSoundsDidChanged
            ),
            PreferenceCellModel(
                id: hapticFeedbackId,
                label: NSLocalizedString("Haptic feedback", comment: ""),
                cellType: .switcher,
                stateDidChanged: hapticFeedbackDidChanged
            )
        ],
        [
            PreferenceCellModel(
                id: "about",
                label: NSLocalizedString("About app", comment: ""),
                cellType: .standart
            )
        ]
    ]
    
    // MARK: - Layout

    override func loadView() {
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = doneItem
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Settings", comment: "")
        
        reloadTable()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
        output.obtainSettings()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.saveSettings()
        output.updateHandler?()
        AppDelegate.AppUtility.unlockPortraitOrientation()
    }
    
    // MARK: - Methods
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func setTappingSoundsSwitcherState(_ isOn: Bool) {
        guard let settingsModel = preferenceList.flatMap({ $0 }).first(where: { $0.id == tappingSoundsId }) else {
            return
        }
        settingsModel.state = isOn
    }
    
    func setHapticFeedbackSwitcherState(_ isOn: Bool) {
        guard let settingsModel = preferenceList.flatMap({ $0 }).first(where: { $0.id == hapticFeedbackId }) else {
            return
        }
        settingsModel.state = isOn
    }
    
    func tappingSoundsDidChanged(_ state: Bool) {
        output.updateTappingSounds(state)
    }
    
    func hapticFeedbackDidChanged(_ state: Bool) {
        output.updateHapticFeedback(state)
    }
    
    func push(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Actions

    @objc func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - DataSource

extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return preferenceList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferenceList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return PreferenceCell(preferenceList[indexPath.section][indexPath.row])
    }
}

// MARK: - Delegate

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]: output.openAppearance()
        case [1,0]: output.openAbout()
        default: break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}


