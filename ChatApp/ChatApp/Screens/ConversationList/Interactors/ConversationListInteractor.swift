//
//  ConversationListInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.03.2021.
//

import Foundation
import Firebase


struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

protocol ConversationListBusinessLogic {
    func getChannelList()
    func createChannel(_ name: String)
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    
    func getChannelList() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else { return }
            let channels = snapshot.documents.compactMap { document -> ChannelModel? in
                guard let name = document["name"] as? String else { return nil }
                
                return ChannelModel(
                    identifier: document.documentID,
                    name: name,
                    lastMessage: document["lastMessage"] as? String,
                    lastActivity: (document["lastActivity"] as? Timestamp)?.dateValue()
                )
            }

            
            DispatchQueue.main.async {
                self?.viewController?.displayList(channels)
            }
        }
    }
    
    func createChannel(_ name: String) {
        
    }
}

