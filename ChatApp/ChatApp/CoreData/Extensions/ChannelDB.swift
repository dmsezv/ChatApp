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
        setLog("---")
        setLog("Chn:\(String(describing: self.name))\n\(String(describing: self.lastMessage))\n")
        if let ms = messages {
            setLog("MSGS:")
            for m in ms {
                setLog("\(String(describing: (m as? MessageDB)?.content))")
            }
        }
        setLog("---")
    }
}
