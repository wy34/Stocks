//
//  SearchResultsViewController.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsControllerDidSelect(searchResult: SearchResult)
}

class SearchResultsViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var results = [SearchResult]()
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
        tv.isHidden = true
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.addSubview(tableView)
        tableView.fill(superView: view)
    }
    
    func update(with results: [SearchResult]) {
        self.results = results
        tableView.isHidden = results.isEmpty
        tableView.reloadData()
    }
}

// MARK: -
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseId, for: indexPath) as! SearchResultTableViewCell
        cell.textLabel?.text = results[indexPath.row].displaySymbol
        cell.detailTextLabel?.text = results[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsControllerDidSelect(searchResult: results[indexPath.row])
    }
}
