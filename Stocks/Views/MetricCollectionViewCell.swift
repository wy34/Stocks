//
//  MetricCollectionViewCell.swift
//  Stocks
//
//  Created by William Yeung on 8/4/21.
//

import UIKit

class MetricCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "MetricCollectionViewCell"
    
    struct ViewModel {
        let name: String
        let value: String
    }
    
    // MARK: - Views
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var labelStack = UIStackView.createStackView(views: [nameLabel, UIView(), valueLabel], distribution: .fill, alignment: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func layoutUI() {
        addSubviews(labelStack)
        labelStack.fill(superView: self)
    }
    
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name + ": "
        valueLabel.text = viewModel.value
    }
}
