//
//  AppearanceViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

private let useSystemAppearanceId = "useSystemAppearance"

protocol AppearanceInput: AnyObject {
    func reloadTable()
    func setUseSystemAppearanceSwitch(isOn: Bool)
    func setCheckmarkedTheme(atRow row: Int)
    func updateLayout(interfaceStyle: UIUserInterfaceStyle)
    func updateNavBarStyle(_ style: Style)
    func overrideUserInterfaceStyle(_ interfaceStyle: UIUserInterfaceStyle)
    func animateUpdateRootViewLayoutSubviews()
}

final class AppearanceViewController: StyledTableViewController, AppearanceInput {
    
    // MARK: - Properties
    
    var output: AppearanceOutput!

    private var checkmarkedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var numberOfSections: Int { countNumberOfSections() }

    lazy var preferenceList = configurePreferenceList()
    
    // MARK: - Layout
    
    override func loadView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        title = NSLocalizedString("Appearance", comment: "")

        output.updateStyleSettings()
        reloadTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockPortraitOrientation()
    }
        
    // MARK: - Methods
    
    private func configurePreferenceList() -> [[PreferenceCellModel]] {
        return [
            [
                SwitchPreferenceCellModel(
                    id: useSystemAppearanceId,
                    text: NSLocalizedString("Use system appearance", comment: ""),
                    switchValueDidChange: useSystemAppearanceSwitchValueDidChange
                )
            ],
            Theme.allCases.map { style in
                CheckmarkPreferenceCellModel(
                    id: style.stringValue,
                    text: style.localizedTitle
                )
            }
        ]
    }
    
    private func countNumberOfSections() -> Int {
        let preferenceModel = preferenceModel(withId: useSystemAppearanceId) as? SwitchPreferenceCellModel
        let isUsingSystemAppearance = preferenceModel?.isOn ?? false
        
        return isUsingSystemAppearance ? 1 : preferenceList.count
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func setUseSystemAppearanceSwitch(isOn: Bool) {
        guard let preferenceModel = preferenceModel(withId: useSystemAppearanceId) as? SwitchPreferenceCellModel else {
            return
        }
        
        preferenceModel.isOn = isOn
    }
    
    func setCheckmarkedTheme(atRow row: Int) {
        checkmarkedIndexPath = IndexPath(row: row, section: 1)
    }
    
    func updateLayout(interfaceStyle: UIUserInterfaceStyle) {
        overrideUserInterfaceStyle(interfaceStyle)
        view.window?.setNeedsLayout()
        view.window?.layoutIfNeeded()
    }
    
    func updateNavBarStyle(_ style: Style) {
        navigationController?.navigationBar.tintColor = style.tintColor
    }
    
    func overrideUserInterfaceStyle(_ interfaceStyle: UIUserInterfaceStyle) {
        view.window?.overrideUserInterfaceStyle = interfaceStyle
    }

    func animateUpdateRootViewLayoutSubviews() {
        if let calcView = view.window?.rootViewController as? CalculatorViewController {
            UIView.animate(withDuration: 0.3, animations: {
                calcView.subviewsSetNeedsLayout()
            })
        }
    }

    func useSystemAppearanceSwitchValueDidChange(_ state: Bool) {
        output.useSystemAppearanceSwitchDidChange(isOn: state)
    }
    
    private func preferenceModel(withId id: PreferenceCellModel.ID) -> PreferenceCellModel? {
        return preferenceList.flattened().first(where: { $0.id == id })
    }
}

// MARK: - DataSource

extension AppearanceViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferenceList[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? NSLocalizedString("Theme", comment: "") : nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let preferenceModel = preferenceList[indexPath.section][indexPath.row]
        let cell = PreferenceCell(preferenceModel: preferenceModel)
        cell.accessoryType = checkmarkedIndexPath == indexPath ? .checkmark : .none
        return cell
    }
}

// MARK: - Delegate

extension AppearanceViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if checkmarkedIndexPath == indexPath {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: checkmarkedIndexPath)?.accessoryType = .none

            output.themeRowDidSelect(at: indexPath.row)
            checkmarkedIndexPath = indexPath

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
