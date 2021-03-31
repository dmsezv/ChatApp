//
//  ChannelDB.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 31.03.2021.
//

import CoreData

extension ChannelDB: DLogging {
    convenience init(channel c: ChannelModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        
        identifier = c.identifier
        name = c.name
        lastMessage = c.lastMessage
        lastActivity = c.lastActivity
    }
    
    func about() {
        log("\(String(describing: self.identifier))\n\(String(describing: self.name))\n\(String(describing: self.lastMessage))\n\(String(describing: self.lastActivity))\n")
    }
}
