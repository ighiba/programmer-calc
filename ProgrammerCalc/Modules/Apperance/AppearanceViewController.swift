//
//  AppearanceViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class AppearanceViewController: StyledTableViewController, AppearanceInput {
    
    // MARK: - Properties
    
    var output: AppearanceOutput!

    var checkmarkedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    lazy var numberOfSections = preferenceList.count

    lazy var preferenceList = [
        [
            PreferenceCellModel(
                id: "useSystemAppearance",
                label: NSLocalizedString("Use system appearance", comment: ""),
                cellType: .switcher,
                stateChangeHandler: useSystemAppearanceDidChanged
            )
        ],
        [
            PreferenceCellModel(
                id: "lightMode",
                label: NSLocalizedString("Light Mode", comment: ""),
                cellType: .checkmark
            ),
            PreferenceCellModel(
                id: "darkMode",
                label: NSLocalizedString("Dark Mode", comment: ""),
                cellType: .checkmark
            ),
            PreferenceCellModel(
                id: "oldSchool",
                label: NSLocalizedString("Old School", comment: ""),
                cellType: .checkmark
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
        
        self.title = NSLocalizedString("Appearance", comment: "")
        output.obtainStyleSettings()
        reloadTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
    }
        
    // MARK: - Methods
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func setIsUseSystemAppearence(_ state: Bool) {
        preferenceList[0][0].state = state
        numberOfSections = state ? 1 : preferenceList.count
    }
    
    func setCheckmarkIndex(for row: Int) {
        checkmarkedIndexPath = IndexPath(row: row, section: 1)
    }
    
    func updateInterfaceLayout(_ style: UIUserInterfaceStyle) {
        overrideUserInterfaceStyle(style)
        self.view.window?.setNeedsLayout()
        self.view.window?.layoutIfNeeded()
    }
    
    func updateNavBarStyle(_ style: Style) {
        self.navigationController?.navigationBar.tintColor = style.tintColor
    }
    
    func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        self.view.window?.overrideUserInterfaceStyle = style
    }

    func animateUpdateRootViewLayoutSubviews() {
        if let calcView = self.view.window?.rootViewController as? CalculatorViewController {
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
        let cell = PreferenceCell(preferenceList[indexPath.section][indexPath.row])
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

            output.setNewStyle(by: indexPath.row)
            checkmarkedIndexPath = indexPath

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
