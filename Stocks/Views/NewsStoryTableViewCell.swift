//
//  NewsStoryTableViewCell.swift
//  Stocks
//
//  Created by William Yeung on 8/1/21.
//

import UIKit
import SDWebImage

class NewsStoryTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "NewsStoryTableViewCell"
    static let preferredHeight = 140
    
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageURL: URL?
        
        init(model: NewsStory) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = model.datetime.toDateString()
            self.imageURL = nil
        }
    }
    
    // MARK: - Views
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.numberOfLines = 4
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sourceLabel, headlineLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 3
        return stack
    }()
    
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
    }
    
    private func layoutUI() {
        addSubviews(storyImageView, labelStackView)
        
        storyImageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.3, hMult: 0.3)
        storyImageView.anchor(trailing: trailingAnchor, padTrailing: 16)
        storyImageView.center(y: centerYAnchor)
        
        labelStackView.anchor(top: storyImageView.topAnchor, trailing: storyImageView.leadingAnchor, bottom: storyImageView.bottomAnchor, leading: leadingAnchor, padTrailing: 14, padLeading: 16)
    }
    
    func configure(with viewModel: ViewModel) {
        sourceLabel.text = viewModel.source
        headlineLabel.text = viewModel.headline
        dateLabel.text = viewModel.dateString
        imageView?.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
