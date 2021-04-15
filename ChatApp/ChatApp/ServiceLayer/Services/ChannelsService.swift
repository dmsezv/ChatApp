//
//  ChannelsService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import Foundation
import Firebase

protocol ChannelsServiceProtocol {
    func subscribeChannelsUpdating(_ eventHandler: @escaping() -> Void)
     func createChannel(_ name: String)
     func deleteChannel(_ identifier: String)
}

class ChannelsService: ChannelsServiceProtocol {
    private let coreDataStack: CoreDataStackProtocol
    private let firebaseManager: FirebaseManagerProtocol
    
    init(coreDataStack: CoreDataStackProtocol,
         firebaseManager: FirebaseManagerProtocol) {
        self.coreDataStack = coreDataStack
        self.firebaseManager = firebaseManager
    }
    
    func createChannel(_ name: String) {
        firebaseManager.createChannel(name)
    }
    
    func deleteChannel(_ identifier: String) {
        firebaseManager.deleteChannel(identifier)
    }
    
    func subscribeChannelsUpdating(_ eventHandler: @escaping() -> Void) {
        firebaseManager.listenChangesChannelList { [weak self] changes in
            guard let changes = changes else { eventHandler(); return }
            
            self?.updateChannels(changes)
            eventHandler()
        }
    }
    
    private func updateChannels(_ changes: [DocumentChange]) {
        coreDataStack.performSave { [weak self] context in
            let deletedIdList = changes
                .filter { $0.type == .removed }
                .compactMap { $0.document.documentID }
            
            if !deletedIdList.isEmpty {
                self?.coreDataStack.delete(from: .channels,
                                           in: context,
                                           by: NSPredicate(format: "identifier IN %@", deletedIdList))
            }
            
            let addedOrModifChannelList = changes
                .filter { $0.type == .added || $0.type == .modified }
            
            let existingChannelsInDb = self?.coreDataStack.read(from: .channels,
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
}
