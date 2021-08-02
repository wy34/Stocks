//
//  UIViewController.swift
//  Stocks
//
//  Created by William Yeung on 8/2/21.
//

import UIKit

extension UIViewController {
    func present(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
