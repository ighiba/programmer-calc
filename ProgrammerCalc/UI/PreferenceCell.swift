//
//  PreferenceCell.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 06.08.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class PreferenceCell: UITableViewCell {

    private let preferenceModel: PreferenceCellModel

    init(_ preferenceModel: PreferenceCellModel) {
        self.preferenceModel = preferenceModel
        super.init(style: .default, reuseIdentifier: preferenceModel.id)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        configureAccessoryView(for: preferenceModel.cellType)
    
        textLabel?.text = preferenceModel.label
        if let systemImageName = preferenceModel.systemImageName {
            imageView?.image = UIImage(systemName: systemImageName)
        }
    }
    
    private func configureAccessoryView(for cellType: PreferenceCellType) {
        switch cellType {
        case .switcher:
            let switcher = UISwitch()
            switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
            switcher.isOn = preferenceModel.state ?? true
            accessoryView = switcher
            selectionStyle = .none
        case .checkmark:
            accessoryType = (preferenceModel.state ?? false) ? .checkmark : .none
        case .button:
            accessoryType = .disclosureIndicator
        case .standart:
            accessoryType = .none
        }
    }
}

extension PreferenceCell {
    @objc func switcherValueChanged(_ sender: UISwitch) {
        preferenceModel.state = sender.isOn
        preferenceModel.stateDidChanged?(sender.isOn)
    }
}
