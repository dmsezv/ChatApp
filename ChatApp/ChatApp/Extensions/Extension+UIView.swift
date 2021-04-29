//
//  Extension+UIView.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 29.04.2021.
//

import UIKit

extension UIView {
    static func animateScale(_ view: UIView, scaleXY: Double = 0.98, duration: Double = 0.2, complete: @escaping() -> Void) {
            UIView.animate(withDuration: duration / 2, animations: {
                view.transform = .init(scaleX: 0.98, y: 0.98)
            }, completion: { _  in
                UIView.animate(withDuration: duration / 2, animations:  {
                    view.transform = .identity
                }) { _ in
                    complete()
                }
            })
        }
}
