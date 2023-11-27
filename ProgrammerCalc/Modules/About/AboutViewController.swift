//
//  AboutViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 19.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit
import MessageUI

private let descriptionIcon = UIImage(systemName: "doc.plaintext")
private let rateAppIcon = UIImage(systemName: "star.square")
private let contactUsIcon = UIImage(systemName: "envelope")

protocol AboutInput: AnyObject {
    func reloadTable()
    func push(_ viewController: UIViewController)
    func openContactFormWith(recipients: [String], subject: String, message: String)
}

class AboutViewController: StyledTableViewController, AboutInput, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    var output: AboutOutput!
    
    lazy var preferenceList = configurePreferenceList()
    
    // MARK: - Layout
    
    override func loadView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        title = NSLocalizedString("About app", comment: "")
        
        tableView.tintColor = navigationController?.navigationBar.tintColor
        
        reloadTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
    }

    override func styleWillUpdate(with style: Style) {
        super.styleWillUpdate(with: style)
        for row in 0 ..< preferenceList.count {
            let indexPath = IndexPath(row: row, section: 1)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.imageView?.tintColor = style.tintColor
        }
    }
    
    // MARK: - Methods
    
    private func configurePreferenceList() -> [PreferenceCellModel] {
        return [
            PreferenceCellModel(
                id: "description",
                label: NSLocalizedString("Description", comment: ""),
                cellType: .standart,
                cellIcon: descriptionIcon
            ),
            PreferenceCellModel(
                id: "rateApp",
                label: NSLocalizedString("Rate app", comment: ""),
                cellType: .standart,
                cellIcon: rateAppIcon
            ),
            PreferenceCellModel(
                id: "contactUs",
                label: NSLocalizedString("Contact us", comment: ""),
                cellType: .standart,
                cellIcon: contactUsIcon
            )
        ]
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openContactFormWith(recipients: [String], subject: String, message: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = view as? MFMailComposeViewControllerDelegate

            mailController.setToRecipients(recipients)
            mailController.setSubject(subject)
            mailController.setMessageBody(message, isHTML: false)
            
            present(mailController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title:  NSLocalizedString("Error", comment: "Error alert title"),
                message: NSLocalizedString("Mail services are not available", comment: ""),
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - DataSource

extension AboutViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return preferenceList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isAppIconCell = indexPath == [0, 0]
        if isAppIconCell {
            let appVersion = UIApplication.appVersion ?? "1.0"
            return AboutAppCell(iconName: "icon-ios-about.png", appVersion: appVersion)
        } else {
            let preferenceModel = preferenceList[indexPath.row]
            let cell = PreferenceCell(preferenceModel)
            cell.imageView?.tintColor = output.obtainTintColor()
            return cell
        }
    }
}

// MARK: - Delegate

extension AboutViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1,0]:
            output.openDescription()
        case [1,1]:
            output.openRateAppForm()
        case [1,2]:
            output.openContactForm()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isAppIconCell = indexPath == [0, 0]
        return isAppIconCell ? 180 : 44
    }
}
