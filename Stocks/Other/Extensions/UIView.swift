//
//  Extensions.swift
//  Stocks
//
//  Created by William Yeung on 7/30/21.
//

import Foundation
import UIKit

// MARK: - Framing
extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return top + height
    }
}

// MARK: - Border
enum Side {
    case top, right, bottom, left
}

extension UIView {
    func addBorder(side: Side, color: UIColor, thickness: CGFloat) {
        let view = UIView()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let topConstraint = view.topAnchor.constraint(equalTo: topAnchor)
        let rightConstraint = view.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leftConstraint = view.leadingAnchor.constraint(equalTo: leadingAnchor)
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: thickness)
        let widthConstraint = view.widthAnchor.constraint(equalToConstant: thickness)
        
        switch side {
        case .top:
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        case .right:
            NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
        case .bottom:
            NSLayoutConstraint.activate([leftConstraint, bottomConstraint, rightConstraint, heightConstraint])
        case .left:
            NSLayoutConstraint.activate([topConstraint, leftConstraint, bottomConstraint, widthConstraint])
        }
    }
}

// MARK: - Anchor
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
    
    func fill(superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, padTop: CGFloat = 0, padTrailing: CGFloat = 0, padBottom: CGFloat = 0, padLeading: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padTop).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padTrailing).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padBottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padLeading).isActive = true
        }
    }
    
    func setDimension(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setDimension(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, wMult: CGFloat = 1, hMult: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: wMult).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: hMult).isActive = true
        }
    }
    
    func center(x: NSLayoutXAxisAnchor? = nil, y: NSLayoutYAxisAnchor? = nil, paddingX: CGFloat = 0, paddingY: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let x = x {
            centerXAnchor.constraint(equalTo: x, constant: paddingX).isActive = true
        }
        
        if let y = y {
            centerYAnchor.constraint(equalTo: y, constant: paddingY).isActive = true
        }
    }
}
