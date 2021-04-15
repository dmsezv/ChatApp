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
        
    let channelsService: ChannelsServiceProtocol
    
    init(channelsService: ChannelsServiceProtocol) {
        self.channelsService = channelsService
    }
    
    func listenChannelChanges() {
        channelsService.subscribeChannelUpdating { [weak self] in
            DispatchQueue.main.async {
                self?.viewController?.channelsLoaded()
            }
        }
    }
    
    func createChannel(_ name: String?) {
        if let name = name, !name.isEmpty {
            channelsService.createChannel(name)
        } else {
            DispatchQueue.main.async {
                self.viewController?.displayError("The channel name should not be empty")
            }
        }
    }
    
    func deleteChannel(_ identifier: String) {
        channelsService.deleteChannel(identifier)
    }
}
