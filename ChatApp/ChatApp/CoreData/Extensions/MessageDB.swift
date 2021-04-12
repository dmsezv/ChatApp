//
//  MessageDB.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 01.04.2021.
//

import CoreData

extension MessageDB {
    convenience init(message m: MessageModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = m.identifier
        self.content = m.content
        self.created = m.created
        self.senderId = m.senderId
        self.senderName = m.senderName
    }
}
