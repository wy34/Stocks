//
//  StockDetailsViewController.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import UIKit
import SafariServices

class StockDetailsViewController: UIViewController {
    // MARK: - Properties
    private let symbol: String
    private let companyName: String
    private var candleStickData: [CandleStick]
    
    private var stories = [NewsStory]()
    private var metrics: Metrics?
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.reuseId)
        tv.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.reuseId)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - Init
    init(symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        fetchNews()
        fetchFinancialData()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.fill(superView: view)
    }
    
    private func fetchNews() {
        APICaller.shared.news(for: .company(symbol: symbol)) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    case .success(let stories):
                        self.stories = stories
                        self.tableView.reloadData()
                    case .failure(let error):
                        self.present(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchFinancialData() {
        let group = DispatchGroup()
        
        if candleStickData.isEmpty {
            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                group.leave()
                guard let self = self else { return }
                switch result {
                    case .success(let response):
                        self.candleStickData = response.candleSticks
                    case .failure(let error):
                        print(error)
                }
            }
        }
        
        group.enter()
        APICaller.shared.financialMetrics(for: symbol) { [weak self] result in
            group.leave()
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    let metrics = response.metric
                    self.metrics = metrics
                case .failure(let error):
                    print(error)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.renderChart()
        }
    }
    
    private func renderChart() {
        let headerView = StockDetailHeaderView(frame: .init(x: 0, y: 0, width: view.width, height: view.width * 0.7 + 100))
        
        var viewModels = [MetricCollectionViewCell.ViewModel]()
        if let metrics = metrics {
            viewModels.append(.init(name: "52W High", value: "\(metrics.AnnualWeekHigh.roundToPlaces(2))"))
            viewModels.append(.init(name: "52L High", value: "\(metrics.AnnualWeekLow.roundToPlaces(2))"))
            viewModels.append(.init(name: "52W Return", value: "\(metrics.AnnualWeekPriceReturnDaily.roundToPlaces(2))"))
            viewModels.append(.init(name: "Beta", value: "\(metrics.beta?.roundToPlaces(2) ?? 0.0)" == "0.0" ? "-" : "\(metrics.beta?.roundToPlaces(2) ?? 0.0)"))
            viewModels.append(.init(name: "10D Vol.", value: "\(metrics.TenDayAverageTradingVolume.roundToPlaces(2))"))
        }
        
        let change = getChangePercentage(data: candleStickData)
        headerView.configure(chartViewModel: .init(data: candleStickData.reversed().map({ $0.close }), showLegend: true, showAxis: true, fillColor: change < 0 ? .systemRed : .systemGreen), metricViewModels: viewModels)
        tableView.tableHeaderView = headerView
    }
    
    private func getChangePercentage(data: [CandleStick]) -> Double {
        let latestDate = data[0].date
        
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: { !Calendar.current.isDate($0.date, inSameDayAs: latestDate) })?.close else { return 0 }
        return 1 - (priorClose/latestClose)
    }
    
    // MARK: - Selector
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.reuseId, for: indexPath) as! NewsStoryTableViewCell
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.reuseId) as? NewsHeaderView else { return nil }
        header.delegate = self
        header.configure(with: .init(title: symbol.uppercased(), shouldShowAddButton: !PersistanceManager.shared.alreadyInWatchList(symbol: symbol)))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: stories[indexPath.row].url) else { return }
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
    }
}

// MARK: - NewsHeaderViewDelegate
extension StockDetailsViewController: NewsHeaderViewDelegate {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView) {
        PersistanceManager.shared.addToWatchList(symbol: symbol, companyName: companyName)
        HapticsManager.shared.vibrateForSelection()
        headerView.hideAddToWatchListButton()
        present(title: "Added to WatchList", message: "We've added \(companyName.capitalized) to your watchlist.")
    }
}
