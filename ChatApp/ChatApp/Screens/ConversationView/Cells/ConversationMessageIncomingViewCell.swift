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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: MessageModel) {
        messageLabel.text = model.text
    }
}
