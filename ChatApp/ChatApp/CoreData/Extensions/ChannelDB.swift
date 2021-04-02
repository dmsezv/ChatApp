//
//  ChannelDB.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 31.03.2021.
//

import CoreData

extension ChannelDB {
    convenience init(channel c: ChannelModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = c.identifier
        self.name = c.name
        self.lastMessage = c.lastMessage
        self.lastActivity = c.lastActivity
    }
}

extension ChannelDB: DLogging {
    func about() {
        printOutput("\nChannel name: \(self.name ?? "undf")")
        if let messages = messages, messages.count > 0 {
            printOutput("Messages:")
            messages.forEach {
                printOutput("\(($0 as? MessageDB)?.senderName ?? "undf") : \(String(describing: ($0 as? MessageDB)?.content ?? "undf"))")
            }
        } else {
            printOutput("No saved message")
        }
    }
    }
