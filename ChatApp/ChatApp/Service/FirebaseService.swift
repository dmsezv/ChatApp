//
//  FirebaseService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 02.04.2021.
//

import Firebase

class FirebaseService {
    private init() {}
    static var shared = FirebaseService()
    
    private let channelCollectonId = "channels"
    private let messagesCollectionId = "messages"
    
    private lazy var db = Firestore.firestore()
    private lazy var channelReference = db.collection(channelCollectonId)
    private var listenerMessages: ListenerRegistration?
    
    func listenChannelList(_ completionHandler: @escaping([ChannelModel]?) -> Void) {
        channelReference.addSnapshotListener { snapshot, _ in
            guard let snapshot = snapshot else { return }
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
    
    func createChannel(_ name: String) {
        channelReference.addDocument(data: ["name": name])
    }
    
    func addDocument(data: [String: Any], to documentId: String) {
        channelReference.document(documentId)
            .collection(messagesCollectionId)
            .addDocument(data: data)
    }
    
    func removeListenerMessages() {
        listenerMessages?.remove()
    }
}
