//
//  NewsHeaderView.swift
//  Stocks
//
//  Created by William Yeung on 7/30/21.
//

import UIKit

protocol NewsHeaderViewDelegate: AnyObject {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

class NewsHeaderView: UITableViewHeaderFooterView {
    // MARK: - Properties
    static let reuseId = "NewsHeaderView"
    static let preferredHeight: CGFloat = 70
    
    weak var delegate: NewsHeaderViewDelegate?
    
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .black)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ WatchList", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    private func layoutUI() {
        addSubviews(label, button)
        label.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, padTrailing: 14, padLeading: 14)
        button.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padTop: 16, padTrailing: 14, padBottom: 16)
        button.setDimension(width: widthAnchor, wMult: 0.28)
    }
    
    func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = viewModel.shouldShowAddButton
    }
    
    // MARK: - Selectors
    @objc private func didTapButton() {
        delegate?.newsHeaderViewDidTapAddButton(self)
    }
}
