//
//  ViewController.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
    // MARK: - Properties
    private var searchTimer: Timer?
    
    private var watchlistMap: [String: [CandleStick]] = [:]
    private var viewModels = [WatchListTableViewCell.ViewModel]()
    
    // MARK: - Views
    private var panel: FloatingPanelController?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(WatchListTableViewCell.self, forCellReuseIdentifier: WatchListTableViewCell.reuseId)
        tv.tableFooterView = UIView()
        tv.rowHeight = WatchListTableViewCell.preferredHeight
        tv.contentInset = .init(top: 0, left: 0, bottom: 360, right: 0)
        tv.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 360, right: 0)
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleView()
        configureUI()
        layoutUI()
        setupSearchController()
        setupNotificationObservers()
        setupFloatingPanel()
        fetchWatchListData()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor)
    }
    
    private func setupSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .didAddToWatchList, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.viewModels.removeAll()
            self.fetchWatchListData()
        }
    }
    
    private func setupFloatingPanel() {
        let panel = FloatingPanelController(delegate: self)
        let customAppearace = SurfaceAppearance()
        customAppearace.cornerRadius = 15
        customAppearace.backgroundColor = .secondarySystemBackground
        panel.surfaceView.appearance = customAppearace
        panel.addPanel(toParent: self)
        
        let vc = NewsViewController(type: .topStories)
        panel.set(contentViewController: vc)
        panel.track(scrollView: vc.tableView)
    }
    
    private func fetchWatchListData() {
        let symbols = PersistanceManager.shared.watchList
        
        let group = DispatchGroup()
        
        for symbol in symbols where watchlistMap[symbol] == nil {
            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                group.leave()
                guard let self = self else { return }
                
                switch result {
                    case .success(let data):
                        self.watchlistMap[symbol] = data.candleSticks
                    case .failure(let error):
                        print(error)
                }
            } 
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.createViewModels()
            self.tableView.reloadData()
        }
    }
    
    private func createViewModels() {
        var viewModels = [WatchListTableViewCell.ViewModel]()
        
        for (symbol, candleSticks) in watchlistMap {
            let changePercentage = getChangePercentage(for: candleSticks)
            
            viewModels.append(
                .init(
                    symbol: symbol,
                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                    price: getLatestClosingPrice(from: candleSticks),
                    changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
                    changePercentage: changePercentage.formattedPercentString(),
                    chartViewModel: .init(data: candleSticks.reversed().map({ $0.close }), showLegend: false, showAxis: false, fillColor: changePercentage < 0 ? .systemRed : .systemGreen)
                )
            )
        }
 
        self.viewModels = viewModels
    }
    
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else { return "" }
        return closingPrice.formattedNumberString()
    }
    
    private func getChangePercentage(for data: [CandleStick]) -> Double {
        let latestDate = data[0].date
        
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: { !Calendar.current.isDate($0.date, inSameDayAs: latestDate) })?.close else {
            return 0
        }
        
        return 1 - (priorClose / latestClose)
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
        
        let vc = StockDetailsViewController(symbol: searchResult.displaySymbol, companyName: searchResult.description)
        vc.navigationItem.title = searchResult.description.capitalized
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
}

// MARK: - FloatingPanelControllerDelegate
extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
        
        var bottomInset: CGFloat = 0
        
        if fpc.state == .tip {
            bottomInset = 70
        } else if fpc.state == .half {
            bottomInset = 360
        }
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: bottomInset, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.reuseId, for: indexPath) as! WatchListTableViewCell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = viewModels[indexPath.row]
        let vc = StockDetailsViewController(symbol: viewModel.symbol, companyName: viewModel.companyName, candleStickData: watchlistMap[viewModel.symbol] ?? [])
        vc.navigationItem.title = viewModel.companyName
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completion in
            guard let self = self else { return }
            let companyToRemove = self.viewModels[indexPath.row]
            PersistanceManager.shared.removeFromWatchList(symbol: companyToRemove.symbol)
            self.viewModels.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
