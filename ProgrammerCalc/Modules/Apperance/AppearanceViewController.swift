//
//  AppearanceViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol AppearanceInput: AnyObject {
    func reloadTable()
    func setIsUseSystemAppearence(_ state: Bool)
    func setCheckmarkIndex(for row: Int)
    func updateInterfaceLayout(_ style: UIUserInterfaceStyle)
    func updateNavBarStyle(_ style: Style)
    func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle)
    func animateUpdateRootViewLayoutSubviews()
}

class AppearanceViewController: StyledTableViewController, AppearanceInput {
    
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

        output.obtainStyleSettings()
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
                PreferenceCellModel(
                    id: "useSystemAppearance",
                    label: NSLocalizedString("Use system appearance", comment: ""),
                    cellType: .switcher,
                    stateChangeHandler: useSystemAppearanceDidChanged
                )
            ],
            Theme.allCases.map { style in
                PreferenceCellModel(
                    id: style.stringValue,
                    label: style.localizedTitle,
                    cellType: .checkmark
                )
            }
        ]
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func setIsUseSystemAppearence(_ state: Bool) {
        preferenceList[0][0].state = state
    }
    
    private func countNumberOfSections() -> Int {
        let isUsingSystemAppearance = preferenceList[0][0].state ?? false
        let count = isUsingSystemAppearance ? 1 : preferenceList.count
        return count
    }
    
    func setCheckmarkIndex(for row: Int) {
        checkmarkedIndexPath = IndexPath(row: row, section: 1)
    }
    
    func updateInterfaceLayout(_ style: UIUserInterfaceStyle) {
        overrideUserInterfaceStyle(style)
        view.window?.setNeedsLayout()
        view.window?.layoutIfNeeded()
    }
    
    func updateNavBarStyle(_ style: Style) {
        navigationController?.navigationBar.tintColor = style.tintColor
    }
    
    func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        view.window?.overrideUserInterfaceStyle = style
    }

    func animateUpdateRootViewLayoutSubviews() {
        if let calcView = view.window?.rootViewController as? CalculatorViewController {
            UIView.animate(withDuration: 0.3, animations: {
                calcView.subviewsSetNeedsLayout()
            })
        }
    }

    func useSystemAppearanceDidChanged(_ state: Bool) {
        output.useSystemAppearance(state)
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
        let cell = PreferenceCell(preferenceModel)
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

            output.setNewTheme(by: indexPath.row)
            checkmarkedIndexPath = indexPath

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
