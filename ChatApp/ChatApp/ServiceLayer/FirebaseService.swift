//
//  FirebaseService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 02.04.2021.
//

import Firebase

protocol FirebaseServiceChannelsProtocol {
    func listenChangesChannelList(_ completeHandler: @escaping([DocumentChange]?) -> Void)
    func createChannel(_ name: String)
    func deleteChannel(_ identifier: String)
}

protocol FirebaseMessagesServiceProtocol {
    func listenChangesMessageList(in identifierChannel: String, _ completeHandler: @escaping([DocumentChange]?) -> Void)
    func sendMessage(_ content: String, to channelId: String)
    func removeListenerMessages()
}

class FirebaseService {
    private let coreDataStack: CoreDataStackProtocol
    
    init(userInfoDataManager usrInfo: UserInfoSaver,
         coreDataStack: CoreDataStackProtocol) {
        senderName = usrInfo.fetchSenderName()
        senderId = usrInfo.fetchSenderId()
        
        self.coreDataStack = coreDataStack
    }
        
    private let channelCollectonId = "channels"
    private let messagesCollectionId = "messages"
    
    private lazy var db = Firestore.firestore()
    private lazy var channelReference = db.collection(channelCollectonId)
    private var listenerMessages: ListenerRegistration?
    
    private let senderName: String
    private let senderId: String
}

// MARK: - Firebase Channels

extension FirebaseService: FirebaseServiceChannelsProtocol {
    func createChannel(_ name: String) {
        channelReference.addDocument(data: ["name": name])
    }
    
    func deleteChannel(_ identifier: String) {
        channelReference.document(identifier).delete()
    }
    
    func listenChangesChannelList(_ completeHandler: @escaping([DocumentChange]?) -> Void) {
        channelReference.addSnapshotListener { [weak self] snapshot, _ in
            guard let snapshot = snapshot else { completeHandler(nil); return }
            self?.updateChannels(snapshot.documentChanges)
            completeHandler(snapshot.documentChanges)
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

    func listenChannelList(_ completionHandler: @escaping([ChannelModel]?) -> Void) {
        channelReference.addSnapshotListener { snapshot, _ in
            guard let snapshot = snapshot else { completionHandler(nil); return }
            let channels = snapshot.documents.compactMap { document -> ChannelModel? in
                guard let name = document["name"] as? String else { return nil }
                
                return ChannelModel(
                    identifier: document.documentID,
                    name: name,
                    lastMessage: document["lastMessage"] as? String,
                    lastActivity: (document["lastActivity"] as? Timestamp)?.dateValue()
                )
            }.sorted(by: { (prev, next) -> Bool in
                prev.lastActivity ?? Date.distantPast > next.lastActivity ?? Date.distantPast
            })
            
            completionHandler(channels)
        }
    }
    
    func getChannelList(_ completionHandler: @escaping([ChannelModel]?) -> Void) {
        channelReference.getDocuments { snapshot, _ in
            guard let snapshot = snapshot else { completionHandler(nil); return }
            let channels = snapshot.documents.compactMap { document -> ChannelModel? in
                guard let name = document["name"] as? String else { return nil }
                
                return ChannelModel(
                    identifier: document.documentID,
                    name: name,
                    lastMessage: document["lastMessage"] as? String,
                    lastActivity: (document["lastActivity"] as? Timestamp)?.dateValue()
                )
            }.sorted(by: { (prev, next) -> Bool in
                prev.lastActivity ?? Date.distantPast > next.lastActivity ?? Date.distantPast
            })
            
            completionHandler(channels)
        }
    }
}

// MARK: - Firebase Messages

extension FirebaseService: FirebaseMessagesServiceProtocol {
    func listenMessageList(in identifierChannel: String, _ completionHandler: @escaping([MessageModel]?) -> Void) {
        listenerMessages = channelReference.document(identifierChannel).collection(messagesCollectionId).addSnapshotListener { snapshot, _ in
            guard let snapshot = snapshot else { return }
            let messages = snapshot.documents.compactMap { document -> MessageModel? in
                guard let content = document["content"] as? String,
                      !content.isEmpty,
                      let created = (document["created"] as? Timestamp)?.dateValue(),
                      let senderId = document["senderId"] as? String,
                      !senderId.isEmpty,
                      let senderName = document["senderName"] as? String,
                      !senderName.isEmpty,
                      !document.documentID.isEmpty
                else { return nil }
                
                return MessageModel(
                    identifier: document.documentID,
                    content: content,
                    created: created,
                    senderId: senderId,
                    senderName: senderName)
            }.sorted(by: { (prev, next) -> Bool in
                prev.created < next.created
            })
            
            completionHandler(messages)
        }
    }
    
    func addDocument(data: [String: Any], to documentId: String) {
        channelReference.document(documentId)
            .collection(messagesCollectionId)
            .addDocument(data: data)
    }
    
    func sendMessage(_ content: String, to channelId: String) {
        channelReference
            .document(channelId)
            .collection(messagesCollectionId)
            .addDocument(data: [
                "content": content,
                "created": Timestamp(date: Date()),
                "senderName": senderName,
                "senderId": senderId
            ])
    }
    
    func removeListenerMessages() {
        listenerMessages?.remove()
    }
    
    func listenChangesMessageList(in identifierChannel: String, _ completeHandler: @escaping([DocumentChange]?) -> Void) {
        listenerMessages = channelReference.document(identifierChannel).collection(messagesCollectionId).addSnapshotListener { [weak self] snapshot, _ in
            guard let snapshot = snapshot else { completeHandler(nil); return }
            self?.updateMessages(snapshot.documentChanges, in: identifierChannel)
            completeHandler(snapshot.documentChanges)
        }
    }
    
    private func updateMessages(_ changes: [DocumentChange], in channelId: String) {
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
