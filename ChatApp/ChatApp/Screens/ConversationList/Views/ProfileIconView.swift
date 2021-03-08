//
//  ProfileIconView.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 08.03.2021.
//

import UIKit

class ProfileIconView: UIView {
    
    @IBOutlet weak var lettersNameLabel: UILabel!
    
    static func instanceFromNib() -> ProfileIconView? {
        return UINib(nibName: String(describing: ProfileIconView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ProfileIconView
    }
}
