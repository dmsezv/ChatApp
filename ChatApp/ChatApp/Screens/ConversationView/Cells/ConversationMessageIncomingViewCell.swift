//
//  ConversationMessageIncomingViewCell.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import UIKit

class ConversationMessageIncomingViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    func configure(with model: MessageModel) {
        messageLabel.text = model.text
        messageView.layer.cornerRadius = cornerRadius
        messageView.layer.maskedCorners = maskedCorners
    }
    
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let maskedCorners: CACornerMask = [
        .layerMaxXMaxYCorner,
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner
    ]
}
