//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by William Yeung on 7/30/21.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "SearchResultTableViewCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
