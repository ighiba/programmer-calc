//
//  DescriptionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 03.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    private let margin: CGFloat = 20

    private let descriptionText: String = NSLocalizedString("DescriptionFullText", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = .systemBackground
        
        descriptionLabel.text = descriptionText
        self.view.addSubview(descriptionLabel)
        descriptionLabel.sizeToFit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let styleFactory: StyleFactory = StyleFactory()
        let styleType = StyleSettings.shared.currentStyle
        let style = styleFactory.get(style: styleType)
        self.navigationController?.navigationBar.tintColor = style.tintColor
    }
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: CGRect(
            x: margin,
            y: margin + self.view.safeAreaInsets.top + 44,
            width: UIScreen.main.bounds.width - margin * 2,
            height: UIScreen.main.bounds.height - margin * 2)
        )

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 5.0
        paragraphStyle.hyphenationFactor = 1.0

        let attributedString = NSAttributedString(string: descriptionText, attributes: [.paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

}


