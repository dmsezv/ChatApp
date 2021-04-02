//
//  FirebaseService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 02.04.2021.
//

import Firebase

class FirebaseService {
    private init() {}
    static let shared = FirebaseService()
    
    private let channelCollectonId = "channels"
    private let messagesCollectionId = "messages"
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection(channelCollectonId)
    private var listenerMessages: ListenerRegistration?
    
    func listenChannelList(_ completionHandler: @escaping([ChannelModel]?) -> Void) {
        listenerMessages = reference.addSnapshotListener { snapshot, _ in
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
    
    func removeListener() {
        listenerMessages?.remove()
    }
}
