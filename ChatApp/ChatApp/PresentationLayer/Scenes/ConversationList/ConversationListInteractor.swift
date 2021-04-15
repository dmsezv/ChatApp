//
//  ConversationListInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.03.2021.
//

import Foundation
import Firebase
import CoreData

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

protocol ConversationListBusinessLogic {
    func listenChannelChanges()
    func createChannel(_ name: String?)
    func deleteChannel(_ identifier: String)
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    let firebaseService: FirebaseServiceChannelsProtocol
    
    init(firebaseService: FirebaseServiceChannelsProtocol) {
        self.firebaseService = firebaseService
    }
    
    //private lazy var firebaseService = FirebaseService.shared
    private lazy var coreDataStack = CoreDataStack.shared
    
    func listenChannelChanges() {
        firebaseService.listenChangesChannelList { [weak self] documentChanges in
            DispatchQueue.main.async {
                self?.viewController?.channelsLoaded()
            }
        }
//        firebaseService.listenChangesChannelList { [weak self] documentChanges in
//            if let documentChanges = documentChanges {
//                self?.coreDataStack.updateInCoreData(channelListChanges: documentChanges)
//                DispatchQueue.main.async {
//                    self?.viewController?.channelsLoaded()
//                }
//            }
//        }
    }
    
    func createChannel(_ name: String?) {
//        if let name = name, !name.isEmpty {
//            firebaseService.createChannel(name)
//        } else {
//            DispatchQueue.main.async {
//                self.viewController?.displayError("The channel name should not be empty")
//            }
//        }
    }
    
    func deleteChannel(_ identifier: String) {
//        firebaseService.deleteChannel(identifier)
    }
}
