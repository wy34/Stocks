//
//  TopStoriesNewsViewController.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit

class NewsViewController: UIViewController {
    // MARK: - Properties
    enum `Type` {
        case topStories
        case company(symbol: String)
        
        var title: String {
            switch self {
                case .topStories:
                    return "Top Stories"
                case .company(symbol: let symbol):
                    return symbol.uppercased()
            }
        }
    }
    
    var type: Type?
    
    private var stories = [
        NewsStory(category: "Tech", datetime: 3, headline: "Some headline should go here!", id: 0, image: "", related: "", source: "CNBC", summary: "", url: ""),
        NewsStory(category: "Tech", datetime: 3, headline: "Some headline should go here!", id: 0, image: "", related: "", source: "CNBC", summary: "", url: "")
    ]
    
    // MARK: - Init
    init(type: Type) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.reuseId)
        tv.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.reuseId)
        tv.backgroundColor = .clear
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.fill(superView: view)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.reuseId, for: indexPath) as! NewsStoryTableViewCell
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.reuseId) as? NewsHeaderView else { return nil }
        header.configure(with: .init(title: self.type?.title ?? "", shouldShowAddButton: false))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
