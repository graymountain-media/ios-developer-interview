//
//  ViewController.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import UIKit

enum SearchScope: Int, CaseIterable {
    case dictionary
    case thesaurus
    
    var displayName: String {
        switch self {
        case .dictionary:
            return "Dictionary"
        case .thesaurus:
            return "Thesaurus"
        }
    }
}

class ViewController: UIViewController {

    var dataSource = TableViewDataSource(state: .empty)
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchText: String = ""
    var selectedScope: SearchScope = .dictionary
    
    var isThesaurus: Bool {
        return selectedScope == .thesaurus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "UIKit Search"
        
        setupTableView()
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = .none
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.scopeBarActivation = .automatic
        
        searchController.searchBar.placeholder = "Search using UIKit"
        /// Didnt have enough time to fully implement
//        searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map({ $0.displayName })
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func search() {
        dataSource.updateState(.searching, isThesaurus: isThesaurus) {
            self.tableView.reloadData()
        }
        API.fetchWord(query: searchText, isThesaurus: isThesaurus) { response in
            switch response {
            case .success(let wordResponse):
                self.dataSource.updateState(.word(wordResponse.word), isThesaurus: self.isThesaurus) {
                    self.reloadData()
                }
                
            case .failure(let error):
                self.dataSource.updateState(.noResults, isThesaurus: self.isThesaurus) {
                    self.reloadData()
                }
                print("NETWORK ERROR: ", error.localizedDescription)
            }
        }
    }
    
    func reloadData() {
        progressIndicator.stopAnimating()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: - UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText = text
    }
}

// MARK: - UISearchResultsUpdating

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !searchText.isEmpty else { return }
        search()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        dataSource.updateState(.empty, isThesaurus: isThesaurus) {
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scope = SearchScope(rawValue: selectedScope) else { return }
        self.selectedScope = scope
    }
}
