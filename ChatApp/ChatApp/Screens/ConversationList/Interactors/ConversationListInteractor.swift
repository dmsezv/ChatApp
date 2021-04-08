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
    func getChannelList()
    func createChannel(_ name: String?)
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    private lazy var firebaseService = FirebaseService.shared
    private lazy var coreDataStack = CoreDataStack.shared
        
    func getChannelList() {
//        firebaseService.listenChannelList { [weak self] channels in
//            guard let channels = channels else { return }
//
//            DispatchQueue.main.async {
//                self?.viewController?.displayList(channels)
//            }
//
//            self?.coreDataStack.saveInCoreData(channels)
//        }
        firebaseService.getChannelList { [weak self] channels in
            guard let channels = channels else { return }
            DispatchQueue.main.async {
                self?.viewController?.displayList(channels)
            }
            
            self?.coreDataStack.saveInCoreData(channels)
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

extension ConversationListInteractor {
    func test() {
        firebaseService.listenChannelList { [weak self] channels in
            guard let channels = channels else { return }
            self?.coreDataStack.saveInCoreData(channels)
            
            
        }
    }
}
