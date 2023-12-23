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
    func setTappingSoundsPreferenceModelSwitch(isOn: Bool)
    func setHapticFeedbackPreferenceModelSwitch(isOn: Bool)
    func push(_ viewController: UIViewController)
}

final class SettingsViewController: StyledTableViewController, SettingsInput, UIAdaptivePresentationControllerDelegate {
    
    // MARK: - Properties
    
    var output: SettingsOutput!
    
    lazy var preferenceList: [[PreferenceCellModel]] = configurePreferenceList()

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
                PushPreferenceCellModel(
                    id: appearanceId,
                    text: NSLocalizedString("Appearance", comment: "")
                ),
                SwitchPreferenceCellModel(
                    id: tappingSoundsId,
                    text: NSLocalizedString("Tapping sounds", comment: ""),
                    switchValueDidChange: tappingSoundsSwitchValueDidChange
                ),
                SwitchPreferenceCellModel(
                    id: hapticFeedbackId,
                    text: NSLocalizedString("Haptic feedback", comment: ""),
                    switchValueDidChange: hapticFeedbackSwitchValueDidChange
                )
            ],
            [
                PushPreferenceCellModel(
                    id: aboutId,
                    text: NSLocalizedString("About app", comment: "")
                )
            ]
        ]
    }
    
    private func setupNavigationBar() {
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(SettingsViewController.closeButtonTapped)
        )
        navigationController?.navigationBar.topItem?.rightBarButtonItem = doneButton
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("Settings", comment: "")
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func setTappingSoundsPreferenceModelSwitch(isOn: Bool) {
        guard let tappingSoundsCellModel = preferenceModel(withId: tappingSoundsId) as? SwitchPreferenceCellModel else {
            return
        }
        
        tappingSoundsCellModel.isOn = isOn
    }
    
    func setHapticFeedbackPreferenceModelSwitch(isOn: Bool) {
        guard let hapticFeedbackCellModel = preferenceModel(withId: hapticFeedbackId) as? SwitchPreferenceCellModel else {
            return
        }
        
        hapticFeedbackCellModel.isOn = isOn
    }
    
    func tappingSoundsSwitchValueDidChange(_ isOn: Bool) {
        output.updateTappingSounds(isOn)
    }
    
    func hapticFeedbackSwitchValueDidChange(_ isOn: Bool) {
        output.updateHapticFeedback(isOn)
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func preferenceModel(withId id: PreferenceCellModel.ID) -> PreferenceCellModel? {
        return preferenceList.flattened().first(where: { $0.id == id })
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
        let preferenceModel = preferenceList[indexPath.section][indexPath.row]
        return PreferenceCell(preferenceModel: preferenceModel)
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
