//
//  WordSizeViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class WordSizeViewController: UIViewController, WordSizeInput {
    
    // MARK: - Properties
    
    var output: WordSizeOutput!
    
    var wordSizeView = WordSizeView()

    private var checkmarkedIndexPath = IndexPath(row: 0, section: 0)
    
    override func loadView() {
        self.view = wordSizeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordSizeView.wordSizeTable.delegate = self
        wordSizeView.wordSizeTable.dataSource = self

        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockPortraitOrientation()
        wordSizeView.animateIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.unlockPortraitOrientation()
    }
    
    // MARK: - Methods
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        swipeUp.cancelsTouchesInView = false
        self.view.addGestureRecognizer(swipeUp)
    }

    private func dismissVC() {
        wordSizeView.animateOut {
            self.dismiss(animated: false, completion: { [weak self] in
                self?.output.updateHandler?()
            })
        }
    }
    
    private func isGestureNotInContainer( gesture: UIGestureRecognizer) -> Bool {
        wordSizeView.container.updateConstraints()
        let currentLocation: CGPoint = gesture.location(in: wordSizeView.container)
        let containerBounds: CGRect = wordSizeView.container.bounds

        return !containerBounds.contains(currentLocation)
    }
    
    func setCheckmarkedIndex(for row: Int) {
        checkmarkedIndexPath = IndexPath(row: row, section: 0)
    }
    
    // MARK: - Actions

    @objc func doneButtonTapped( sender: UIButton) {
        dismissVC()
    }
    
    @objc func tappedOutside( sender: UITapGestureRecognizer) {
        let notInContainer: Bool = isGestureNotInContainer(gesture: sender)
        if notInContainer {
            dismissVC()
        }
    }
    
    @objc func handleSwipe( sender: UISwipeGestureRecognizer) {
        let notInContainer: Bool = isGestureNotInContainer(gesture: sender)
        if notInContainer {
            dismissVC()
        }
    }
}

// MARK: - DataSource

extension WordSizeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WordSizeType.allCases.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = WordSizeType.allCases[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        cell.textLabel?.textColor = .label
        cell.backgroundColor = .systemGray6
        cell.selectionStyle = .default

        cell.accessoryType = checkmarkedIndexPath == indexPath ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkmarkedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: checkmarkedIndexPath)?.accessoryType = .none

        output.setNewWordSize(by: indexPath.row)
        output.obtainCheckmarkIndex()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
