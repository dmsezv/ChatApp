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
    func createChannel(_ name: String?)
    func unsubscribeChannel()
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    private var listenerMessages: ListenerRegistration?
        
    func getChannelList() {
        reference.addSnapshotListener { [weak self] snapshot, _ in
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

            self?.saveInCoreData(channels)
            
            DispatchQueue.main.async {
                self?.viewController?.displayList(channels)
            }
        }
    }
    
    func createChannel(_ name: String?) {
        if let name = name, !name.isEmpty {
            reference.addDocument(data: ["name": name])
        } else {
            DispatchQueue.main.async {
                self.viewController?.displayError("The channel name should not be empty")
            }
        }
    }
    
    func unsubscribeChannel() {
        listenerMessages?.remove()
    }
}

// MARK: - Core Data

extension ConversationListInteractor {
    private func saveInCoreData(_ channels: [ChannelModel]) {
        //UserInfoSaverGCD
        DispatchQueue.global().async {
            CoreDataStack.shared.performSave { (context) in
                for c in channels {
                    _ = ChannelDB(channel: c, in: context)
                }
            }
        }
    }
}
