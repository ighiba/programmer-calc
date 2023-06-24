//
//  AboutPresenter.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 23.06.2023.
//  Copyright © 2023 ighiba. All rights reserved.
//

import UIKit
import StoreKit

protocol AboutInput: AnyObject {
    func reloadTable()
    func push(_ viewController: UIViewController)
    func openContactFormWith(recipients: [String], subject: String, message: String)
}

protocol AboutOutput: AnyObject {
    func obtainTintColor() -> UIColor
    func openDescription()
    func openRateAppForm()
    func openContactForm()
}

class AboutPresenter: AboutOutput {
    
    // MARK: - Properties
    
    weak var view: AboutInput!
    
    var styleManager: StyleManager!
    
    // MARK: - Methods

    func obtainTintColor() -> UIColor {
        return styleManager.obtainStyle().tintColor
    }
    
    func openDescription() {
        let descriptionView = DescriptionViewController()
        descriptionView.title = NSLocalizedString("Description", comment: "")
        view.push(descriptionView)
    }
    
    func openRateAppForm() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive} ) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    func openContactForm() {
        let model = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        let appVersion = UIApplication.appVersion ?? "1.0"
        let buildNumber = UIApplication.buildNumber ?? "1"

        let recipients = ["ighiba.dev@gmail.com"]
        let subject = "Programmer's Calculator support"
        let message = "Model - \(model), OS - \(systemVersion), App version - \(appVersion)(\(buildNumber))"
        
        view.openContactFormWith(recipients: recipients, subject: subject, message: message)
    }
}

