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
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    private let firebaseService = FirebaseService.shared
    private let coreDataStack = CoreDataStack.shared
        
    func getChannelList() {
        firebaseService.listenChannelList { [weak self] channels in
            guard let channels = channels else { return }
            
            DispatchQueue.main.async {
                self?.viewController?.displayList(channels)
            }
        }
    }
    
    func createChannel(_ name: String?) {
        if let name = name, !name.isEmpty {
            firebaseService.createChannel(name)
        } else {
            DispatchQueue.main.async {
                self.viewController?.displayError("The channel name should not be empty")
            }
        }
    }
}

// MARK: - Core Data

extension ConversationListInteractor {
    private func saveInCoreData(_ channels: [ChannelModel]) {
        coreDataStack.performSave { (context) in
            channels.forEach { _ = ChannelDB(channel: $0, in: context) }
        }
    }
}
