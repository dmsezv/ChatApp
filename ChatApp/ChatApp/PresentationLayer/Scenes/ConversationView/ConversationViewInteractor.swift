//
//  ConversationViewInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 24.03.2021.
//

import Foundation
import Firebase

protocol ConversationViewBusinessLogic {
    func listenMessagesChanges()
    func send(_ message: String)
    func unsubscribeChannel()
    
    var channel: ChannelModel? { get set }
}

class ConversationViewInteractor: ConversationViewBusinessLogic {
    weak var viewController: ConversationViewDisplayLogic?
    var channel: ChannelModel?
    
    private lazy var userInfoGCD = UserInfoSaverGCD()
    private lazy var senderId: String = userInfoGCD.fetchSenderId()
    private var senderName: String = ""
    
    let messagesService: MessagesServiceProtocol
    
    init(messagesService: MessagesServiceProtocol) {
        self.messagesService = messagesService
    }
    
    func send(_ message: String) {
        guard let channel = channel else {
            return
        }
        
        messagesService.send(message, to: channel.identifier)
    }
    
    func listenMessagesChanges() {
        guard let channel = channel else {
            return
        }
        
        messagesService.subscribeMessagesUpdating(in: channel.identifier) { [weak self] in
            DispatchQueue.main.async {
                self?.viewController?.messagesLoaded()
            }
            
        }
    }
    
    func unsubscribeChannel() {
        messagesService.removeListenerMessages()
    }
}
