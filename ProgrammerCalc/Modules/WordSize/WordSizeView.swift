//
//  WordSizeView.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class WordSizeView: UIView, ModalView {
    
    let margin: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    func setViews() {
        self.frame = UIScreen.main.bounds

        self.backgroundColor = .clear
        
        container.addSubview(containerStack)
        self.addSubview(container)

        setupLayout()

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 0)
    }

    func setupLayout() {
        let popoverTitleHeight: CGFloat = popoverTitle.font.pointSize + 1
        let tableRowHeight: CGFloat = 44
        let doneButtonHeight: CGFloat = 50
        let containerStackHeight: CGFloat =  popoverTitleHeight + margin * 2 + tableRowHeight * 4 + doneButtonHeight
        
        popoverTitle.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        wordSizeTable.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            popoverTitle.heightAnchor.constraint(equalToConstant: popoverTitleHeight),
            
            wordSizeTable.heightAnchor.constraint(equalToConstant: tableRowHeight * 4),
            
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight),

            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: modalViewWidth),
            container.heightAnchor.constraint(equalToConstant: containerStackHeight+margin * 2),

            containerStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            containerStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
            containerStack.heightAnchor.constraint(equalToConstant: containerStackHeight),
        ])
    }
    
    let container: UIView = {
        let view = UIView()

        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 24

        return view
    }()

    let wordSizeTable: UITableView = {
        let table = UITableView(frame: CGRect(), style: .plain)
        
        table.isScrollEnabled = false
        
        return table
    }()

    var doneButton: UIButton = {
        return PopoverDoneButton()
    }()

    private let popoverTitle: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("Change word size", comment: "")
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
               
        return label
    }()

    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popoverTitle,wordSizeTable,doneButton])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        let containerStackHeight = ((UIScreen.main.bounds.height * 0.55) * 0.9) * 0.9

        stack.setCustomSpacing(margin, after: popoverTitle)
        stack.setCustomSpacing(margin, after: wordSizeTable)
        
        return stack
    }()
    
    func animateIn() {
        let moveUp = CGAffineTransform(translationX: 0, y: -300)
        let scaleDown = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let transform = scaleDown.concatenating(moveUp)

        self.container.transform = transform
        self.alpha = 0
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        }, completion: nil)
    }

    func animateOut(completion: @escaping () -> Void) {
        let moveUp = CGAffineTransform(translationX: 0, y: -300)
        let scaleDown = CGAffineTransform(scaleX: 0.01, y: 0.01)

        let transform = scaleDown.concatenating(moveUp)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.container.transform = transform
            self.container.alpha = 0.01
            self.alpha = 0
        }, completion: { _ in
            completion()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
