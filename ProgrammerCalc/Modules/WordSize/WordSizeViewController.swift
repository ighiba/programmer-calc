//
//  WordSizeViewController.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 07.10.2021.
//  Copyright © 2021 ighiba. All rights reserved.
//

import UIKit

protocol WordSizeInput: AnyObject {
    func setCheckmarkedIndex(for row: Int)
}

class WordSizeViewController: ModalViewController, WordSizeInput {

    var output: WordSizeOutput!
    
    private let wordSizeView: WordSizeView

    private var checkmarkedIndexPath = IndexPath(row: 0, section: 0)
    
    init() {
        self.wordSizeView = WordSizeView()
        super.init(modalView: wordSizeView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordSizeView.wordSizeTableView.delegate = self
        wordSizeView.wordSizeTableView.dataSource = self

        output.updateCheckmarkIndex()
    }

    override func updateHandler() {
        output.updateHandler?()
    }
    
    func setCheckmarkedIndex(for row: Int) {
        checkmarkedIndexPath = IndexPath(row: row, section: 0)
    }
}

// MARK: - UITableViewDataSource

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

        output.didSelectRow(at: indexPath.row)
        output.updateCheckmarkIndex()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
