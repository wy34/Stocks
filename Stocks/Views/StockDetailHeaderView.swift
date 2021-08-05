//
//  StockDetailHeaderView.swift
//  Stocks
//
//  Created by William Yeung on 8/4/21.
//

import UIKit

class StockDetailHeaderView: UIView {
    // MARK: - Properties
    private var metricViewModels = [MetricCollectionViewCell.ViewModel]()
    
    // MARK: - Views
    private let chartView = StockChartView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MetricCollectionViewCell.self, forCellWithReuseIdentifier: MetricCollectionViewCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .secondarySystemBackground
        return cv
    }()
    
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
        addSubviews(chartView, collectionView)
        
        chartView.setDimension(width: widthAnchor, height: heightAnchor, hMult: 0.75)
        chartView.anchor(top: topAnchor, leading: leadingAnchor)
        
        collectionView.setDimension(width: widthAnchor, height: heightAnchor, hMult: 0.25)
        collectionView.anchor(bottom: bottomAnchor, leading: leadingAnchor)
    }
    
    func configure(chartViewModel: StockChartView.ViewModel, metricViewModels: [MetricCollectionViewCell.ViewModel]) {
        self.metricViewModels = metricViewModels
        chartView.configure(with: chartViewModel)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension StockDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metricViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.reuseId, for: indexPath) as! MetricCollectionViewCell
        cell.configure(with: metricViewModels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (width-48)/2, height: (collectionView.height-16)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 16, bottom: 0, right: 16)
    }
}
