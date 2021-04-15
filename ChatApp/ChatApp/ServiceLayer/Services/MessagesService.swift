//
//  MessagesService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import Foundation
import Firebase

protocol MessagesServiceProtocol {
    func subscribeMessagesUpdating(in channelId: String, _ eventHandler: @escaping () -> Void)
    func send(_ message: String, to channelId: String)
    func removeListenerMessages()
}

class MessagesService: MessagesServiceProtocol {
    private let coreDataStack: CoreDataStackProtocol
    private let firebaseManager: FirebaseManagerProtocol
    private let userInfoDataManager: UserInfoSaver
    
    init(coreDataStack: CoreDataStackProtocol,
         firebaseManager: FirebaseManagerProtocol,
         userInfoDataManager: UserInfoSaver) {
        self.userInfoDataManager = userInfoDataManager
        self.coreDataStack = coreDataStack
        self.firebaseManager = firebaseManager
    }
    
    func send(_ message: String, to channelId: String) {
        let data: [String: Any] = [
            "content": message,
            "created": Timestamp(date: Date()),
            "senderName": userInfoDataManager.fetchSenderName(),
            "senderId": userInfoDataManager.fetchSenderId()
        ]
        firebaseManager.addMessage(data: data, to: channelId)
    }
    
    func removeListenerMessages() {
        firebaseManager.removeListenerMessages()
    }
    
    func subscribeMessagesUpdating(in channelId: String, _ eventHandler: @escaping () -> Void) {
        firebaseManager.listenChangesMessageList(in: channelId) { [weak self] changes in
            guard let changes = changes else { eventHandler(); return }
            self?.updateMessages(changes, in: channelId)
            
            eventHandler()
        }
    }
    
    private func updateMessages(_  changes: [DocumentChange], in channelId: String) {
        coreDataStack.performSave { [weak self] context in
            guard let channel = self?.coreDataStack.read(from: .channels,
                                     in: context,
                                     by: NSPredicate(format: "identifier == %@", channelId))?.first as? ChannelDB
            else { return }
            
            let deletedIdList = changes
                .filter { $0.type == .removed }
                .compactMap { $0.document.documentID }
            
            if !deletedIdList.isEmpty {
                self?.coreDataStack.delete(from: .messages,
                    in: context,
                    by: NSPredicate(format: "identifier IN %@", deletedIdList))
            }
            
            let addedOrModifMessages = changes
                .filter { $0.type == .added || $0.type == .modified }
            
            let existingMessagesInDb = self?.coreDataStack.read(from: .messages,
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
