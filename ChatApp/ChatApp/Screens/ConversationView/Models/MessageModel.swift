//
//  MessageModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import Foundation

protocol MessageCellConfiguration {
    var text: String { get set }
    var isIncoming: Bool { get set }
}


class MessageModel: MessageCellConfiguration {
    var text: String
    var isIncoming: Bool
    
    init(text: String, isIncoming: Bool) {
        self.text = text
        self.isIncoming = isIncoming
    }
}
