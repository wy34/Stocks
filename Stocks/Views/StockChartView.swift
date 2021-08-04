//
//  StockChartView.swift
//  Stocks
//
//  Created by William Yeung on 8/2/21.
//

import UIKit

class StockChartView: UIView {
    // MARK: - Properties
    
    // MARK: - Views
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    func reset() {
        
    }
    
    func configure(with viewModel: ViewModel) {
        
    }
}
