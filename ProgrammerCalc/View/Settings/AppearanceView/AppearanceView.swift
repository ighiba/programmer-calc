//
//  AppearanceView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 25.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class AppearanceView: UITableView {
    
    // MARK: - Properties
    
    // AppearanceViewController delegate
    weak var controllerDelegate: AppearanceViewControllerDelegate?
    
    private let useSystemAppearanceCell = [ NSLocalizedString("Use system appearance", comment: "")]
    
    private let customStyleCells = [        NSLocalizedString("Light Mode", comment: ""),
                                            NSLocalizedString("Dark Mode", comment: ""),
                                            NSLocalizedString("Old School", comment: "")]
    

    // MARK: - Inititalization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var appearanceSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = controllerDelegate?.isUsingSystemAppearance() ?? true
        switcher.addTarget(nil, action: #selector(AppearanceViewController.changeUseSystemStyle), for: .valueChanged)
        return switcher
    }()
    

}

// MARK: - DataSource
extension AppearanceView: UITableViewDataSource {
    
    // Num of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        if let isSystemAppearance = controllerDelegate?.isUsingSystemAppearance() {
            return isSystemAppearance ? 1 : 2
        } else {
            return 1
        }
    }
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return useSystemAppearanceCell.count
        } else {
            return customStyleCells.count
        }
    }
    
    // Header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("Theme", comment: "")
        } else {
            return nil
        }
    }
    
    // Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath {
        case [0,0]:
            // Use system appearance
            cell.textLabel?.text = useSystemAppearanceCell[indexPath.row]
            // add switcher
            cell.accessoryView = appearanceSwitch
            // disable selection style
            cell.selectionStyle = .none
            break
        case [1,0], [1,1], [1,2]:
            // Light Mode, Dark Mode, Oldschool
            cell.textLabel?.text = customStyleCells[indexPath.row]
            // set checkmark
            if let checkmarkedIndexPath = controllerDelegate?.checkmarkedIndexPath {
                if checkmarkedIndexPath == indexPath {
                    cell.accessoryType = .checkmark
                }
            }
        default:
            break
        }
        
        return cell
    }
    
}
