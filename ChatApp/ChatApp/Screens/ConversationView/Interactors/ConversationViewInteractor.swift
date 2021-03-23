//
//  ConversationViewInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 24.03.2021.
//

import Foundation
import Firebase

protocol ConversationViewBusinessLogic {
    func getMessagesBy(_ identifierChannel: String)
}

class ConversationViewInteractor: ConversationViewBusinessLogic {
    weak var viewController: ConversationViewDisplayLogic?
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    func getMessagesBy(_ identifierChannel: String) {
        reference.document(identifierChannel).collection("messages").addSnapshotListener { [weak self] (snapshot, error) in
            guard let snapshot = snapshot else { return }
            let messages = snapshot.documents.compactMap { document -> MessageModel? in
                guard let content = document["content"] as? String,
                      !content.isEmpty,
                      let created = (document["created"] as? Timestamp)?.dateValue(),
                      let senderId = document["senderId"] as? String,
                      !senderId.isEmpty,
                      let senderName = document["senderName"] as? String,
                      !senderName.isEmpty
                else { return nil }
                
                return MessageModel(content: content, created: created, senderId: senderId, senderName: senderName)
            }
            
            DispatchQueue.main.async {
                self?.viewController?.displayList(messages)
            }
        }
    }
}
