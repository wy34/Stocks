//
//  SearchResultsViewController.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsControllerDidSelect(searchResult: String)
}

class SearchResultsViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var results = [String]()
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
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
    
    func update(with results: [String]) {
        self.results = results
        tableView.reloadData()
    }
}

// MARK: -
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseId, for: indexPath) as! SearchResultTableViewCell
        cell.textLabel?.text = "AAPL"
        cell.detailTextLabel?.text = "Apple Inc."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsControllerDidSelect(searchResult: "AAPL")
    }
}
