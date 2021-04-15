//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import Firebase

protocol FirebaseManagerProtocol {
    func listenChangesChannelList(_ completeHandler: @escaping([DocumentChange]?) -> Void)
    func createChannel(_ name: String)
    func deleteChannel(_ identifier: String)
    func listenChangesMessageList(in identifierChannel: String, _ completeHandler: @escaping([DocumentChange]?) -> Void)
    func send(_ message: MessageModel, to channelId: String)
    func removeListenerMessages()
}

class FirebaseManager: FirebaseManagerProtocol {
    private init() {}
    static let shared = FirebaseManager()
    
    private let channelCollectonId = "channels"
    private let messagesCollectionId = "messages"
    
    private lazy var db = Firestore.firestore()
    private lazy var channelReference = db.collection(channelCollectonId)
    private var listenerMessages: ListenerRegistration?
    
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
    
    func addDocument(data: [String: Any], to documentId: String) {
        channelReference.document(documentId)
            .collection(messagesCollectionId)
            .addDocument(data: data)
    }
    
    func send(_ message: MessageModel, to channelId: String) {
        channelReference
            .document(channelId)
            .collection(messagesCollectionId)
            .addDocument(data: [
                "content": message.content,
                "created": Timestamp(date: Date()),
                "senderName": message.senderName,
                "senderId": message.senderId
            ])
    }
    
    func removeListenerMessages() {
        listenerMessages?.remove()
    }
    
    func listenChangesMessageList(in identifierChannel: String, _ completeHandler: @escaping([DocumentChange]?) -> Void) {
        listenerMessages = channelReference.document(identifierChannel).collection(messagesCollectionId).addSnapshotListener { snapshot, _ in
            guard let snapshot = snapshot else { completeHandler(nil); return }
            
            completeHandler(snapshot.documentChanges)
        }
    }
    
    
}
