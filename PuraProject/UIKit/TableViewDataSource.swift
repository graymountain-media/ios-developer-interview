//
//  TableViewDataSource.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation
import UIKit

enum DataState {
    case empty
    case searching
    case noResults
    case word(Word)
}

class TableViewDataSource: NSObject {
    var state: DataState
    var isThesaurus: Bool = false
    init(state: DataState) {
        self.state = state
    }
    
    func updateState(_ state: DataState, isThesaurus: Bool, completion: @escaping () -> ()) {
        self.state = state
        self.isThesaurus = isThesaurus
        DispatchQueue.main.async {
            completion()
        }
    }
}

extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let DataState.word(word) = state else {
            return 1
        }
        return word.definitions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dictionaryRow(tableView, cellForRowAt: indexPath)
    }
    
    func thesaurusRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func dictionaryRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch state {
        case .word(let word):
            if indexPath.row == 0 {
                guard let wordCell = tableView.dequeueReusableCell(withIdentifier: "wordCell") as? WordCell else {
                    fatalError("Check table data cofiguration for word cell")
                }
                wordCell.configure(word: word.text)
                cell = wordCell
            } else {
                guard let defCell = tableView.dequeueReusableCell(withIdentifier: "definitionCell") as? DefinitionCell else {
                    fatalError("Check table data cofiguration for word cell")
                }
                defCell.configure(number: indexPath.row, definition: word.definitions[indexPath.row - 1])
                cell = defCell
            }
        case .searching:
            guard let progressCell = tableView.dequeueReusableCell(withIdentifier: "progressCell") as? ProgressCell else {
                fatalError("Check table data cofiguration for empty state cell")
            }
            cell = progressCell
        case .empty:
            guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyStateCell") as? EmptyStateCell else {
                fatalError("Check table data cofiguration for empty state cell")
            }
            emptyCell.configure(state: .emptySearch)
            cell = emptyCell
        case .noResults:
            guard let noResultsCell = tableView.dequeueReusableCell(withIdentifier: "emptyStateCell") as? EmptyStateCell else {
                fatalError("Check table data cofiguration for no results cell")
            }
            noResultsCell.configure(state: .noResultsFound)
            cell = noResultsCell
        }
        cell.selectionStyle = .none
        return cell
    }
}
