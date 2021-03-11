//
//  ConversationListTableViewCell.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.03.2021.
//

import UIKit


class ConversationListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLetterView: UIView!
    @IBOutlet weak var nameLetterLabel: UILabel!
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = ThemePicker.shared.currentTheme.backgroundColor
        nameLabel.textColor = ThemePicker.shared.currentTheme.textColor
    }
    
    func configure(with model: ConversationCellConfiguration) {
        nameLabel.text = model.name ?? "Unknown user"
        nameLabel.font = .boldSystemFont(ofSize: fontSize)
        
        if let message = model.message {
            messageLabel.text = message
            messageLabel.font = model.hasUnreadMessages
                ? .boldSystemFont(ofSize: fontSize)
                : .systemFont(ofSize: fontSize)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: fontSize)
        }
        
        if let date = model.date {
            dateLabel.text = Calendar.current.isDateInToday(date)
                ? "Today \(date.toString(format: "HH:mm"))"
                : date.toString(format: "dd MMM")
        }
        
        backgroundColor = model.online
            ? .bananaHalf
            : .white
        
        nameLetterView.layer.cornerRadius = nameLetterView.bounds.size.width / 2
        nameLetterLabel.text = model.name?.first?.uppercased() ?? "U"
    }
    
    
    // MARK: - Drawing Constants
    
    let fontSize: CGFloat = 17
}
