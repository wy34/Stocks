//
//  UILabel.swift
//  Stocks
//
//  Created by William Yeung on 8/3/21.
//

import UIKit

class PaddedLabel: UILabel {
    // MARK: - Properties
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    // MARK: - Init
    init(text: String, padding: CGFloat) {
        self.topInset = padding
        self.bottomInset = padding
        self.leftInset = padding
        self.rightInset = padding
        super.init(frame: .zero)
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += rightInset + leftInset
            return contentSize
        }
    }
}
