//
//  SettingsViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit
import MessageUI

private let appearanceId = "appearance"
private let tappingSoundsId = "tappingSounds"
private let hapticFeedbackId = "hapticFeedback"
private let aboutId = "about"

protocol SettingsInput: AnyObject {
    func reloadTable()
    func setTappingSoundsSwitcherState(isOn: Bool)
    func setHapticFeedbackSwitcherState(isOn: Bool)
    func push(_ viewController: UIViewController)
}

final class SettingsViewController: StyledTableViewController, SettingsInput, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    var output: SettingsOutput!
    
    lazy var preferenceList = configurePreferenceList()

    // MARK: - Layout

    override func loadView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        setupNavigationBar()
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

    private func configurePreferenceList() -> [[PreferenceCellModel]] {
        return [
            [
                PreferenceCellModel(
                    id: appearanceId,
                    label: NSLocalizedString("Appearance", comment: ""),
                    cellType: .button
                ),
                PreferenceCellModel(
                    id: tappingSoundsId,
                    label:  NSLocalizedString("Tapping sounds", comment: ""),
                    cellType: .switcher,
                    stateChangeHandler: tappingSoundsSwitchStateDidChange
                ),
                PreferenceCellModel(
                    id: hapticFeedbackId,
                    label: NSLocalizedString("Haptic feedback", comment: ""),
                    cellType: .switcher,
                    stateChangeHandler: hapticFeedbackSwitchStateDidChange
                )
            ],
            [
                PreferenceCellModel(
                    id: aboutId,
                    label: NSLocalizedString("About app", comment: ""),
                    cellType: .standart
                )
            ]
        ]
    }
    
    private func setupNavigationBar() {
        let doneItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(SettingsViewController.closeButtonTapped)
        )
        navigationController?.navigationBar.topItem?.rightBarButtonItem = doneItem
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("Settings", comment: "")
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func setTappingSoundsSwitcherState(isOn: Bool) {
        guard let settingsModel = preferenceList.flatMap({ $0 }).first(where: { $0.id == tappingSoundsId }) else {
            return
        }
        
        settingsModel.state = isOn
    }
    
    func setHapticFeedbackSwitcherState(isOn: Bool) {
        guard let settingsModel = preferenceList.flatMap({ $0 }).first(where: { $0.id == hapticFeedbackId }) else {
            return
        }
        
        settingsModel.state = isOn
    }
    
    func tappingSoundsSwitchStateDidChange(_ isOn: Bool) {
        output.updateTappingSounds(isOn)
    }
    
    func hapticFeedbackSwitchStateDidChange(_ isOn: Bool) {
        output.updateHapticFeedback(isOn)
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Actions

    @objc func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        let selectedId = preferenceList[indexPath.section][indexPath.row].id
        
        switch selectedId {
        case appearanceId:
            output.openAppearance()
        case aboutId:
            output.openAbout()
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
