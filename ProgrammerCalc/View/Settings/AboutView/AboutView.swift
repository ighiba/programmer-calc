//
//  AboutView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 20.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class AboutView: UITableView {
    
    // AboutViewController delegate
    weak var controllerDelegate: AboutViewControllerDelegate?
    
    private let cellLabels = [ NSLocalizedString("Description", comment: ""),
                               NSLocalizedString("Rate app", comment: ""),
                               NSLocalizedString("Contact us", comment: "")]
    
    var iconTint: UIColor {
        let styleStorage = StyleStorage()
        let styleType = styleStorage.safeGetStyleData()
        let style = StyleFactory().get(style: styleType)
        return style.tintColor
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // change cells view tint color
        for row in 0...cellLabels.count {
            let cell = cellForRow(at: IndexPath(row: row, section: 1))
            cell?.imageView?.tintColor = iconTint
        }
    }
    
}

extension AboutView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return cellLabels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // setup icon cell
        if indexPath == [0,0] {
            // image view for app icon
            let appIcon = UIImageView()
            appIcon.image = UIImage(named: "icon-ios-about.png")
            appIcon.frame = CGRect(x: 0, y: 0, width: 114, height: 114)
            appIcon.layer.cornerRadius = 18
            appIcon.layer.masksToBounds = true
            // version label
            let versionLabel = UILabel()
            // get version
            let appVersion = UIApplication.appVersion ?? "1.0"
            versionLabel.text = "ProgrammerCalc \(appVersion)"
            versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
            versionLabel.textColor = .systemGray
            
            cell.addSubview(appIcon)
            cell.addSubview(versionLabel)

            // Constraints for app icon and logo
            appIcon.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                appIcon.widthAnchor.constraint(equalToConstant: 114),
                appIcon.heightAnchor.constraint(equalToConstant: 114),
                appIcon.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                appIcon.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: -10),
                versionLabel.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 10),
                versionLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                versionLabel.widthAnchor.constraint(equalToConstant: versionLabel.intrinsicContentSize.width),
                versionLabel.heightAnchor.constraint(equalToConstant: versionLabel.intrinsicContentSize.height),
            ])
            
            // disable selection style
            cell.selectionStyle = .none
        } else {
            cell.textLabel?.text = cellLabels[indexPath.row]
            // color for icon before text
            cell.imageView?.tintColor = iconTint
            
            switch indexPath.row {
            case 0:
                // Description icon
                cell.imageView?.image = UIImage(systemName: "doc.plaintext")
            case 1:
                // Rate app icon
                cell.imageView?.image = UIImage(systemName: "star.square")
            case 2:
                // Contact us icon
                cell.imageView?.image = UIImage(systemName: "envelope")
            default:
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = controllerDelegate {
            switch indexPath {
            case [1,0]:
                // Description
                controller.openDescription()
                break
            case [1,1]:
                // Rate app
                controller.rateApp()
            case [1,2]:
                // Contact us
                controller.openContactForm()
                break
            default:
                break
            }
        }
   
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,0] {
            return 180 // height for icon cell
        } else {
            return 44 // default height
        }
    }
    
}
