//
//  ConversationListInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.03.2021.
//

import Foundation
import Firebase
import CoreData

protocol ConversationListBusinessLogic {
    func listenChannelChanges()
    func createChannel(_ name: String?)
    func deleteChannel(_ identifier: String)
    func fetchSenderName() -> String
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    let channelsRepository: ChannelRepositoryProtocol
    let channelsService: ChannelsServiceProtocol
    let userInfoService: UserInfoServiceProtocol
    
    init(channelsService: ChannelsServiceProtocol,
         userInfoService: UserInfoServiceProtocol,
         channelsRepository: ChannelRepositoryProtocol) {
        self.channelsService = channelsService
        self.userInfoService = userInfoService
        self.channelsRepository = channelsRepository
    }
    
    func listenChannelChanges() {
        channelsService.subscribeChannelsUpdating { [weak self] in
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
    
    func fetchSenderName() -> String {
        userInfoService.senderName
    }
}
