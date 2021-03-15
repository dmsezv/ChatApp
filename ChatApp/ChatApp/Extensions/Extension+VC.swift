//
//  Extension+VC.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.02.2021.
//

import UIKit

extension UIViewController: DLogging {}

extension UIViewController {
    public func hideKeyboardWhenTapAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
