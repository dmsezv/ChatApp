//
//  CoreDataStack+SaveModels.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 02.04.2021.
//

import CoreData
import Firebase

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
    
    func removeFromCoreData(_ channels: [ChannelModel]) {
        performSave { (context) in
            channels.forEach { context.delete(ChannelDB(channel: $0, in: context)) }
        }
    }

    // TODO: отрефакторить как следует
    func updateInCoreData(channelListChanges: [DocumentChange]) {
        let entityName = String(describing: ChannelDB.self)
        
        performSave { context in
            let deletedIdList = channelListChanges
                .filter { $0.type == .removed }
                .compactMap { $0.document.documentID }
            
            if !deletedIdList.isEmpty {
                delete(from: entityName,
                    in: context,
                    by: NSPredicate(format: "identifier IN %@", deletedIdList))
            }
            
            let addedOrModifChannelList = channelListChanges
                .filter { $0.type == .added || $0.type == .modified }
            
            let existingChannelsInDb = read(from: entityName,
                                            in: context,
                                            by: NSPredicate(format: "identifier IN %@",
                                                            addedOrModifChannelList
                                                                .compactMap { $0.document.documentID })) as? [ChannelDB]
            
            addedOrModifChannelList.forEach { change in
                guard let name = change.document["name"] as? String else { return }
                
                if let existingChannelsInDb = existingChannelsInDb?
                    .first(where: { $0.identifier == change.document.documentID }) {
                    existingChannelsInDb.setValue(name, forKey: "name")
                    existingChannelsInDb.setValue(change.document["lastMessage"] as? String, forKey: "lastMessage")
                    existingChannelsInDb.setValue((change.document["lastActivity"] as? Timestamp)?.dateValue(), forKey: "lastActivity")
                } else {
                    let channel = ChannelModel(
                        identifier: change.document.documentID,
                        name: name,
                        lastMessage: change.document["lastMessage"] as? String,
                        lastActivity: (change.document["lastActivity"] as? Timestamp)?.dateValue()
                    )
                    
                    _ = ChannelDB(channel: channel, in: context)
                }
            }
        }
    }
    
    // TODO: отрефакторить как следует
    func updateInCoreData(messageListChanges: [DocumentChange], in channelId: String) {
        performSave { context in
            guard let channel = read(from: entityChannelDBName,
                                     in: context,
                                     by: NSPredicate(format: "identifier == %@", channelId))?.first as? ChannelDB
            else { return }
            
            let deletedIdList = messageListChanges
                .filter { $0.type == .removed }
                .compactMap { $0.document.documentID }
            
            if !deletedIdList.isEmpty {
                delete(from: entityMessageDBName,
                    in: context,
                    by: NSPredicate(format: "identifier IN %@", deletedIdList))
            }
            
            let addedOrModifMessages = messageListChanges
                .filter { $0.type == .added || $0.type == .modified }
            
            let existingMessagesInDb = read(from: entityMessageDBName,
                                            in: context,
                                            by: NSPredicate(format: "identifier IN %@", addedOrModifMessages
                                                                .compactMap { $0.document.documentID })) as? [MessageDB]
            
            addedOrModifMessages.forEach { change in
                guard let content = change.document["content"] as? String,
                      !content.isEmpty,
                      let created = (change.document["created"] as? Timestamp)?.dateValue(),
                      let senderId = change.document["senderId"] as? String,
                      !senderId.isEmpty,
                      let senderName = change.document["senderName"] as? String,
                      !senderName.isEmpty,
                      !change.document.documentID.isEmpty
                else { return }
                
                if let existingMessagesInDb = existingMessagesInDb?
                    .first(where: { $0.identifier == change.document.documentID }) {
                    existingMessagesInDb.setValue(content, forKey: "content")
                    existingMessagesInDb.setValue(created, forKey: "created")
                    existingMessagesInDb.setValue(senderId, forKey: "senderId")
                    existingMessagesInDb.setValue(senderName, forKey: "senderName")
                } else {
                    channel.addToMessages(MessageDB(message: MessageModel(
                                                        identifier: change.document.documentID,
                                                        content: content,
                                                        created: created,
                                                        senderId: senderId,
                                                        senderName: senderName),
                                                    in: context))
                }
            }
        }
    }
}
