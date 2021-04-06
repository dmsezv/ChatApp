//
//  CoreDataStack+SaveModels.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 02.04.2021.
//

import CoreData

extension CoreDataStack {
    func saveInCoreData(_ messages: [MessageModel], from channel: ChannelModel) {
        performSave { (context) in
            let messagesDB: [MessageDB] = messages.compactMap { msg in
                return MessageDB(message: msg, in: context)
            }
            
            let chn = ChannelDB(channel: channel, in: context)
            messagesDB.forEach { chn.addToMessages($0) }
        }
    }
    
    func saveInCoreData(_ channels: [ChannelModel]) {
        performSave { (context) in
            channels.forEach { _ = ChannelDB(channel: $0, in: context) }
        }
    }
    
    func fetch() {
        //ChannelDB.fetchRequest()
    }
}
