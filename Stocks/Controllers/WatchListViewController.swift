//
//  ViewController.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit

class WatchListViewController: UIViewController {
    // MARK: - Properties
    private var searchTimer: Timer?
    
    // MARK: - Views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleView()
        configureUI()
        layoutUI()
        setupSearchController()
    }

    // MARK: - Helpers
    private func setupTitleView() {
        let titleView = UIView(frame: .init(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100))
        let label = UILabel(frame: .init(x: 10, y: 0, width: titleView.width, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 30, weight: .black)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func layoutUI() {
        
    }
    
    private func setupSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
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
        
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            APICaller.shared.search(query: query) { result in
                switch result {
                    case .success(let response):
                        DispatchQueue.main.async {
                            resultsVC.update(with: response.result)
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            resultsVC.update(with: [])
                        }
                }
            }
        })
    }
}

// MARK: - SearchResultsViewControllerDelegate
extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsControllerDidSelect(searchResult: SearchResult) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        let vc = StockDetailsViewController()
        vc.navigationItem.title = searchResult.description
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
}
