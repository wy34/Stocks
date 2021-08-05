//
//  StockChartView.swift
//  Stocks
//
//  Created by William Yeung on 8/2/21.
//

import UIKit
import Charts

class StockChartView: UIView {
    // MARK: - Properties
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
    }
    
    // MARK: - Views
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        return chartView
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
        addSubview(chartView)
        chartView.fill(superView: self)
    }
    
    func reset() {
        
    }
    
    func configure(with viewModel: ViewModel) {
        var entries = [ChartDataEntry]()
        
        for (index, value) in viewModel.data.enumerated() {
            entries.append(.init(x: Double(index), y: value))
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Some Label")
        dataSet.fillColor = .systemBlue
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
}
