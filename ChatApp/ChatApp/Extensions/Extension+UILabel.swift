//
//  Extension+UILabel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 23.02.2021.
//

import UIKit


extension UILabel {
    func addCharacterSpacing(kernValue: Double = 3) {
        if let labelText = text, labelText.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.kern,
                                          value: kernValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
