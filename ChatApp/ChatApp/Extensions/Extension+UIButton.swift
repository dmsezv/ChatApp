//
//  Extension+UIButton.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 08.03.2021.
//

import UIKit

extension UIButton {
    func setBackground(_ view: UIView) {
        view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        view.isUserInteractionEnabled = false
        self.addSubview(view)
    }
}
