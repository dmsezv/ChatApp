//
//  ConversationMessageIncomingViewCell.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import UIKit

class ConversationMessageOutgoingViewCell: UITableViewCell {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
    }
    
    func configure(with model: MessageCellConfiguration) {
        messageLabel.text = model.text
        messageView.layer.cornerRadius = cornerRadius
        messageView.layer.maskedCorners = maskedCorners
        
        messageView.backgroundColor = ThemePicker.shared.currentTheme.cellOutgoingBackground
        messageLabel.textColor = ThemePicker.shared.currentTheme.cellOutgoingTextColor
    }
    
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let maskedCorners: CACornerMask = [
        .layerMaxXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMinXMinYCorner
    ]
}
