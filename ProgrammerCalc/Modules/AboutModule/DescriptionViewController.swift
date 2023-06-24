//
//  DescriptionViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 03.11.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class DescriptionViewController: StyledViewController {
    
    private let margin: CGFloat = 20
    private let navBarHeight: CGFloat = 44

    private let descriptionText: String = NSLocalizedString("DescriptionFullText", comment: "")

    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: CGRect(
            x: margin,
            y: margin + self.view.safeAreaInsets.top + navBarHeight,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = .systemBackground
        
        descriptionLabel.text = descriptionText
        self.view.addSubview(descriptionLabel)
        descriptionLabel.sizeToFit()
    }
}


