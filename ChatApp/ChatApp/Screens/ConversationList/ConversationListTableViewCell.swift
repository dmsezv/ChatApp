//
//  ConversationListTableViewCell.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.03.2021.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: ConversationCellConfiguration) {
        nameLabel.text = model.name
        nameLabel.font = .boldSystemFont(ofSize: fontSize)
        
        if let message = model.message {
            messageLabel.text = message
            messageLabel.font = model.hasUnreadMessages
                ? .boldSystemFont(ofSize: fontSize)
                : .systemFont(ofSize: fontSize)
        }
        
        if let date = model.date {
            dateLabel.text = Calendar.current.isDateInToday(date)
                ? date.toString(format: "HH:mm")
                : date.toString(format: "dd MMM")
        }
        
        backgroundColor = model.online
            ? .blue
            : .white
    }
    
    
    // MARK: - Drawing Constants
    
    let fontSize: CGFloat = 17
}
