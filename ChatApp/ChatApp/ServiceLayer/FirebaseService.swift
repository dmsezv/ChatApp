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
    
    static var shared = FirebaseService()
    
    private let channelCollectonId = "channels"
    private let messagesCollectionId = "messages"
    
    private lazy var db = Firestore.firestore()
    private lazy var channelReference = db.collection(channelCollectonId)
    private var listenerMessages: ListenerRegistration?
    
    private let senderName: String
    private let senderId: String
}

extension FirebaseService: FirebaseServiceChannelsProtocol {
    func createChannel(_ name: String) {
        channelReference.addDocument(data: ["name": name])
    }
    
    func deleteChannel(_ identifier: String) {
        channelReference.document(identifier).delete()
    }
    
    func listenChangesChannelList(_ completeHandler: @escaping([DocumentChange]?) -> Void) {
        channelReference.addSnapshotListener { snapshot, _ in
            guard let snapshot = snapshot else { completeHandler(nil); return }
            completeHandler(snapshot.documentChanges)
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
}

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
    
    func listenChangesMessageList(in identifierChannel: String, _ completeHandler: @escaping([DocumentChange]?) -> Void) {
        listenerMessages = channelReference.document(identifierChannel).collection(messagesCollectionId).addSnapshotListener { snapshot, _ in
            guard let snapshot = snapshot else { completeHandler(nil); return }
            completeHandler(snapshot.documentChanges)
        }
    }
}
