//
//  UIStackView.swift
//  Stocks
//
//  Created by William Yeung on 8/3/21.
//

import UIKit

extension UIStackView {
    static func createStackView(views: [UIView], spacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .horizontal, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .center) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.spacing = spacing
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        return stackView
    }
}
