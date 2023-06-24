//
//  AboutAppCell.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

class AboutAppCell: UITableViewCell {
    
    private let appIcon = UIImageView()
    private let versionLabel = UILabel()
    
    private let iconWidth: CGFloat = 114
    
    init(iconName: String, appVersion: String) {
        super.init(style: .default, reuseIdentifier: "aboutAppCell")

        appIcon.image = UIImage(named: iconName)
        appIcon.layer.cornerRadius = 18
        appIcon.layer.masksToBounds = true

        versionLabel.text = "Programmer's Calculator \(appVersion)"
        versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        versionLabel.textColor = .systemGray
        
        self.addSubview(appIcon)
        self.addSubview(versionLabel)

        self.selectionStyle = .none
        
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appIcon.widthAnchor.constraint(equalToConstant: iconWidth),
            appIcon.heightAnchor.constraint(equalToConstant: iconWidth),
            appIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            appIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            versionLabel.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 10),
            versionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            versionLabel.widthAnchor.constraint(equalToConstant: versionLabel.intrinsicContentSize.width),
            versionLabel.heightAnchor.constraint(equalToConstant: versionLabel.intrinsicContentSize.height),
        ])
        
        super.updateConstraints()
    }
}
