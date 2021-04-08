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

    func updateInCoreData(_ channelListChanges: [DocumentChange]) {
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
            
            let relevantChannelsInDb = read(from: entityName,
                                            in: context,
                                            by: NSPredicate(format: "identifier IN %@",
                                                            addedOrModifChannelList
                                                                .compactMap { $0.document.documentID })) as? [ChannelDB]
            
            addedOrModifChannelList.forEach { change in
                guard let name = change.document["name"] as? String else { return }
                
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
    
    func updateInCoreData(_ messageListChanges: [DocumentChange], in channelId: String) {
        let entityChannelDBName = String(describing: MessageDB.self)
        let entityMessageDBName = String(describing: ChannelDB.self)

        performSave { context in
            guard let channel = read(
                    from: entityMessageDBName,
                    in: context,
                    by: NSPredicate(
                        format: "identifier IN %@", channelId))?.first as? ChannelDB else { return }
            
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
            
            addedOrModifMessages.forEach { change in
                channel.addToMessages(<#T##value: MessageDB##MessageDB#>)
            }
        }
    }
}

// MARK: - Copy Read Update Delete

extension CoreDataStack {
    private func delete(from entity: String, in context: NSManagedObjectContext, by predicate: NSPredicate) {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        request.predicate = predicate
        
        do {
            let objs = try context.fetch(request)
            objs.forEach { context.delete($0) }
        } catch {
            printOutput(error.localizedDescription)
        }
    }
    
    private func read(from entity: String, in context: NSManagedObjectContext, by predicate: NSPredicate? = nil) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        request.predicate = predicate
        
        do {
            let res = try context.fetch(request)
            return res
        } catch {
            printOutput(error.localizedDescription)
            return nil
        }
    }
    
    private func update(from entity: String, valuesForKeys: [String: Any], in context: NSManagedObjectContext, by predicate: NSPredicate) {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        request.predicate = predicate
        
        do {
            if let res = try context.fetch(request).first {
                res.setValuesForKeys(valuesForKeys)
            }
        } catch {
            printOutput(error.localizedDescription)
        }
    }
}
