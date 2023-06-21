//
//  WordSizeViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class WordSizeViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var wordSizeView = WordSizeView()

    // links to storage
    private let storage = CalculatorStorage()
    // variable for filling and changing table checkmarks
    private let wordSize: WordSize = WordSize.shared
    // index of table checkmarks
    private var checkmarkedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    // update all layout in parent vc
    var updaterHandler: (() -> Void)?
    
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
        let loadedWordSize: WordSize = storage.loadData()
        wordSize.setWordSize(loadedWordSize)
        wordSizeView.animateIn()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.unlockPortraitOrientation()
    }
    
    // MARK: - Methods
    
    fileprivate func setupGestures() {
        // tap outside popup(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        // swipe up for dismiss
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        swipeUp.cancelsTouchesInView = false
        self.view.addGestureRecognizer(swipeUp)
    }

    // ViewConvtroller dismissing
    fileprivate func dismissVC() {
        // anation
        wordSizeView.animateOut {
            self.dismiss(animated: false, completion: {
                // update all layout in main vc (CalculatorView)
                guard self.updaterHandler != nil else {
                    return
                }
                self.updaterHandler!()
            })
        }
    }
    
    fileprivate func isGestureNotInContainer( gesture: UIGestureRecognizer) -> Bool {
        wordSizeView.container.updateConstraints()
        let currentLocation: CGPoint = gesture.location(in: wordSizeView.container)
        let containerBounds: CGRect = wordSizeView.container.bounds

        return !containerBounds.contains(currentLocation)
    }
    
    // MARK: - Actions
    
    // Done button / Exit button
    @objc func doneButtonTapped( sender: UIButton) {
        dismissVC()
    }
    
    @objc func tappedOutside( sender: UITapGestureRecognizer) {
        let notInContainer: Bool = isGestureNotInContainer(gesture: sender)
        
        if notInContainer {
            // does not contains
            // dismiss vc
            dismissVC()
        }
    }
    
    // Swipe up to exit
    @objc func handleSwipe( sender: UISwipeGestureRecognizer) {
        let notInContainer: Bool = isGestureNotInContainer(gesture: sender)
        if notInContainer {
            // does not contains
            // dismiss vc
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
        
        if indexPath.row == WordSizeType.allCases.firstIndex(of: wordSize.value)! {
            cell.accessoryType = .checkmark
            checkmarkedIndexPath = indexPath
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkmarkedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: checkmarkedIndexPath)?.accessoryType = .none
        
        checkmarkedIndexPath = indexPath
        
        let newValue = WordSizeType.allCases[indexPath.row]
        wordSize.setWordSizeValue(newValue)
        
        storage.saveData(wordSize)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
