//
//  SettingsView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsView: UITableView {
    
    // SettingsViewController delegate
    var controllerDelegate: SettingsViewControllerDelegate?
    
    // First section array
    let firstSection = [ "Dark mode", "Tapping sounds", "Haptic feedback"]
    // Second section array
    let otherSection = ["About app", "Contact us"]
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    
    // Number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return otherSection.count
        default:
            return firstSection.count
        }
    }
    // Returns cell for section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AppSettingsCell()
        let title = indexPath.section == 0 ? firstSection[indexPath.row] : otherSection[indexPath.row]
        if indexPath.section == 0 {
            cell = AppSettingsCell(style: .default, reuseIdentifier: "cellId", label: title, switcher: true)
        } else {
            cell = AppSettingsCell(style: .default, reuseIdentifier: "cellId", label: title, switcher: false)
        }
        
        return cell
    }
    // Numer of sections Main + other
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
            // Version label
            let appVersion = controllerDelegate?.appVersion ?? "1.0"
            label.text = "Programmer Calc \(appVersion)"
            label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
            label.textAlignment = .center
            
            self.sectionFooterHeight = 30
            
            return label
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard controllerDelegate != nil else {
            return
        }
        
        // Section 1 handling
        switch indexPath {
        case [1,0]:
            // About app
            break
        case [1,1]:
            // Contact us
            controllerDelegate!.openContactForm()
            break
        default:
            // do nothing
            break
        }
        
        
        // Handle deselection of row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

