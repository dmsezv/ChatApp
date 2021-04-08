//
//  MessageModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import Foundation

struct MessageModel {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    var isIncoming: Bool {
        senderId != UserInfoSaverGCD().fetchSenderId()
    }
    
    static func createFrom(_ messageDB: MessageDB) -> MessageModel? {
        guard
            let idntf = messageDB.identifier,
            let content = messageDB.content,
            let created = messageDB.created,
            let sId = messageDB.senderId,
            let sName = messageDB.senderName
        else {
            return nil
        }
        
        return MessageModel(
            identifier: idntf,
            content: content,
            created: created,
            senderId: sId,
            senderName: sName)
    }
}
