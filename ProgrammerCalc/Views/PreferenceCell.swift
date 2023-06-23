//
//  PreferenceCell.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PreferenceCell: UITableViewCell {

    var preferenceModel: PreferenceCellModel

    init(_ preferenceModel: PreferenceCellModel) {
        self.preferenceModel = preferenceModel
        super.init(style: .default, reuseIdentifier: preferenceModel.id)
        
        switch preferenceModel.cellType {
        case .switcher:
            let switcher = UISwitch()
            switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
            switcher.isOn = preferenceModel.state ?? true
            self.accessoryView = switcher
            self.selectionStyle = .none
        case .checkmark:
            self.accessoryType = (preferenceModel.state ?? false) ? .checkmark : .none
        case .button:
            self.accessoryType = .disclosureIndicator
        case .standart:
            self.accessoryType = .none
        }
    
        self.textLabel?.text = preferenceModel.label
        if let systemImageName = preferenceModel.systemImageName {
            self.imageView?.image = UIImage(systemName: systemImageName)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switcherValueChanged(_ sender: UISwitch) {
        preferenceModel.state = sender.isOn
        preferenceModel.stateDidChanged?(sender.isOn)
    }
}
