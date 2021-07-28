//
//  ViewController.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit

class WatchListViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupSearchController()
    }

    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func layoutUI() {
        
    }
    
    private func setupSearchController() {
        let resultVC = SearchResultsViewController()
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
}

// MARK: - UISearchResultsUpdating
extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              query.trimmingCharacters(in: .whitespaces) != "" else { return }
        
        print(query)
    }
}
