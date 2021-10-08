//
//  WordSizeViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

class WordSizeViewController: UIViewController {
    // ==================
    // MARK: - Properties
    // ==================
    
    lazy var wordSizeView = WordSizeView()

    // links to storages
    private var wordSizeStorage: WordSizeStorageProtocol = WordSizeStorage()
    // variable for filling and changing table checkmarks
    private var wordSize: WordSize?
    // index of table checkmarks
    private var checkmarkedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    // update all layout in parent vc
    var updaterHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate and dataSource for table
        wordSizeView.wordSizeTable.delegate = self
        wordSizeView.wordSizeTable.dataSource = self
        
        self.view = wordSizeView
        
        // tap outside popup(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // load data from UserDefaults to table
        getWordSize()
        // animate popover
        wordSizeView.animateIn()
    }
    
    // ===============
    // MARK: - Methods
    // ===============
    
    // Update table values with
    fileprivate func getWordSize() {
        // get data from UserDefaults
        if let wordSize = wordSizeStorage.loadData() {
            self.wordSize = wordSize as? WordSize
        }  else {
            print("no wordSize")
            // Save default settings
            self.wordSize = WordSize(64)
            wordSizeStorage.saveData(self.wordSize!)
        }
    }
 
    // ViewConvtroller dismissing
    fileprivate func dismissVC() {
        // anation
        wordSizeView.animateOut {
            self.dismiss(animated: false, completion: {
                // update all layout in root vc (PCalcViewController)
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
    
    // ===============
    // MARK: - Actions
    // ===============
    
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
}

// MARK: - TableView Data Source

extension WordSizeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (wordSize?.wordsDictionary.count)!
    }
    
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = wordSize!.wordsDictionary[indexPath.row].keys.first
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        cell.selectionStyle = .default
        
        if wordSize?.wordsDictionary[indexPath.row].values.first == wordSize?.value {
            cell.accessoryType = .checkmark
            checkmarkedIndexPath = indexPath
        }
        
        return cell
    }
    
    // Tap on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkmarkedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        // set checkmark on new cell
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // remove from old
        tableView.cellForRow(at: checkmarkedIndexPath)?.accessoryType = .none
        
        // update checkmarkedIndexPath
        checkmarkedIndexPath = indexPath
        
        // update wordSize value
        wordSize?.value = (wordSize?.wordsDictionary[indexPath.row].first!.value)!
        
        // update user defaults
        wordSizeStorage.saveData(wordSize!)
        
        //checkmarkedIndexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
