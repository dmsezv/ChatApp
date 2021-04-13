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
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var timeMessageLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with model: MessageModel) {
        timeMessageLabel.text = model.created.toString(format: "HH:mm")
        senderNameLabel.text = model.senderName
        messageLabel.text = model.content
        messageView.layer.cornerRadius = cornerRadius
        messageView.layer.maskedCorners = maskedCorners
        
        messageView.backgroundColor = ThemePicker.shared.currentTheme.cellIncomingBackground
        messageLabel.textColor = ThemePicker.shared.currentTheme.cellIncomingTextColor
    }
        
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10
    let maskedCorners: CACornerMask = [
        .layerMaxXMaxYCorner,
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner
    ]
}
