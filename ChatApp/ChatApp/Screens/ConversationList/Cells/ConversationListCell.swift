//
//  ConversationListTableViewCell.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.03.2021.
//

import UIKit


class ConversationListCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLetterView: UIView!
    @IBOutlet weak var nameLetterLabel: UILabel!
    
    
    // MARK: - Drawing Constants
    
    let fontSize: CGFloat = 17
        
    
    //MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.textColor = ThemePicker.shared.currentTheme.textColor
    }
    
    func configure(with model: ChannelModel) {
        nameLabel.text = model.name
        nameLabel.font = .boldSystemFont(ofSize: fontSize)
        
        if let message = model.lastMessage {
            messageLabel.text = message
            messageLabel.font = .systemFont(ofSize: fontSize)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: fontSize)
        }
        
        if let date = model.lastActivity {
            dateLabel.text = Calendar.current.isDateInToday(date)
                ? "Today \(date.toString(format: "HH:mm"))"
                : date.toString(format: "dd MMM")
        } else {
            dateLabel.text = "No date"
        }
        
        
        nameLetterView.layer.cornerRadius = nameLetterView.bounds.size.width / 2
        nameLetterLabel.text = model.name.first?.uppercased() ?? "U"
    }
}
