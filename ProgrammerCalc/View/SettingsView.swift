//
//  SettingsView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 05.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SettingsView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }
    // First section array
    let firstSection = [ "Dark mode", "Tapping sounds", "Haptic feedback"]
    // Second section array
    let otherSection = ["About app", "Contact us"]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsView: UITableViewDataSource {
    
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
        let cell: SettingsCell
        let title = indexPath.section == 0 ? firstSection[indexPath.row] : otherSection[indexPath.row]
        if indexPath.section == 0 {
            cell = SettingsCell(style: .default, reuseIdentifier: "cellId", label: title, switcher: true)
        } else {
            cell = SettingsCell(style: .default, reuseIdentifier: "cellId", label: title, switcher: false)
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
            label.text = "Programmer Calc 0.6.1"
            label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
            label.textAlignment = .center
            
            self.sectionFooterHeight = 30
            
            return label
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle deselection of row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SettingsView: UITableViewDelegate {

}

