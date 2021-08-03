//
//  WatchListTableViewCell.swift
//  Stocks
//
//  Created by William Yeung on 8/2/21.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "WatchListTableViewCell"
    static let preferredHeight: CGFloat = 60
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String
        let changeColor: UIColor
        let changePercentage: String
    }
    
    // MARK: - Views
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let miniChartView = StockChartView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubviews(symbolLabel, companyLabel, priceLabel, changeLabel)
    }
    
    func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
    }
}
