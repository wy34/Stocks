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
    static let preferredHeight: CGFloat = 90
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String
        let changeColor: UIColor
        let changePercentage: String
        let chartViewModel: StockChartView.ViewModel
    }
    
    // MARK: - Views
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var companyStack = UIStackView.createStackView(views: [symbolLabel, companyLabel], axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = PaddedLabel(text: "", padding: 5)
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var priceStack = UIStackView.createStackView(views: [priceLabel, changeLabel], spacing: 5, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.clipsToBounds = true
        return chart
    }()
    
    private lazy var overallStack = UIStackView.createStackView(views: [companyStack, miniChartView, priceStack], spacing: 16, distribution: .fill, alignment: .fill)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubview(overallStack)
        
        overallStack.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTop: 16, padTrailing: 16, padBottom: 16, padLeading: 16)
        companyStack.setDimension(width: widthAnchor, wMult: 0.4)
        
        priceStack.translatesAutoresizingMaskIntoConstraints = false
        priceStack.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.18).isActive = true
    }
    
    func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
        miniChartView.configure(with: viewModel.chartViewModel)
    }
}
