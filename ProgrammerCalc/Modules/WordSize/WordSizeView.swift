//
//  WordSizeView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

private let verticalSpacing: CGFloat = 20
private let tableRowHeight: CGFloat = 44
private let doneButtonHeight: CGFloat = PopoverDoneButton.defaultHeight
private let containerStackWidthMultiplier: CGFloat = 0.9
private let containerCornerRadius: CGFloat = 24

class WordSizeView: UIView, ModalView {

    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
        setupLayout()
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setupView() {
        let blurredBackgroundView = makeBlurredBackgroundView()
        insertSubview(blurredBackgroundView, at: 0)
        container.addSubview(containerStack)
        addSubview(container)
    }

    private func setupLayout() {
        let titleHeight: CGFloat = titleLabel.font.pointSize + 1
        let tableRowCount: Int = WordSizeType.allCases.count
        let tableHeight: CGFloat = tableRowHeight * CGFloat(tableRowCount)
        let containerStackHeight: CGFloat = titleHeight + verticalSpacing * 2 + tableHeight + doneButtonHeight

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        wordSizeTableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: titleHeight),

            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: modalViewContainerWidth),
            container.heightAnchor.constraint(equalToConstant: containerStackHeight + verticalSpacing * 2),

            containerStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            containerStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: containerStackWidthMultiplier),
            containerStack.heightAnchor.constraint(equalToConstant: containerStackHeight),
            
            wordSizeTableView.heightAnchor.constraint(equalToConstant: tableRowHeight * 4),
            
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight),
        ])
    }
    
    private func setupStyle() {
        backgroundColor = .clear

        container.backgroundColor = .systemGray6

        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Change word size", comment: "")
        label.textAlignment = .center
        return label
    }()
    
    let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = containerCornerRadius
        return view
    }()

    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, wordSizeTableView, doneButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.setCustomSpacing(verticalSpacing, after: titleLabel)
        stack.setCustomSpacing(verticalSpacing, after: wordSizeTableView)
        return stack
    }()
    
    let wordSizeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var doneButton: UIButton = {
        return PopoverDoneButton()
    }()
}
