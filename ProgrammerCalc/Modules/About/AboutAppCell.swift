//
//  AboutAppCell.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit

private let iconWidth: CGFloat = 114
private let verticalSpacing: CGFloat = 10

final class AboutAppCell: UITableViewCell {
    
    private let appIcon = UIImageView()
    private let versionLabel = UILabel()
    
    init(iconName: String, appVersion: String) {
        super.init(style: .default, reuseIdentifier: "aboutAppCell")
        self.setupView(iconName: iconName, appVersion: appVersion)
        self.setupStyle()
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            appIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -verticalSpacing),
            appIcon.widthAnchor.constraint(equalToConstant: iconWidth),
            appIcon.heightAnchor.constraint(equalToConstant: iconWidth),

            versionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: verticalSpacing),
            versionLabel.widthAnchor.constraint(equalToConstant: versionLabel.intrinsicContentSize.width),
            versionLabel.heightAnchor.constraint(equalToConstant: versionLabel.intrinsicContentSize.height),
        ])
        
        super.updateConstraints()
    }
    
    private func setupView(iconName: String, appVersion: String) {
        selectionStyle = .none
        
        appIcon.image = UIImage(named: iconName)
        appIcon.layer.cornerRadius = 18
        appIcon.layer.masksToBounds = true

        versionLabel.text = "Programmer's Calculator \(appVersion)"
        
        addSubview(appIcon)
        addSubview(versionLabel)
    }
    
    private func setupStyle() {
        versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        versionLabel.textColor = .systemGray
    }
}
