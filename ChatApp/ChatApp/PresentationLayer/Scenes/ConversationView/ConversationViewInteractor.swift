//
//  ConversationViewInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 24.03.2021.
//

import CoreData
import Firebase

protocol ConversationViewBusinessLogic {
    var channel: ChannelModel? { get set }
    
    func listenMessagesChanges()
    func send(_ message: String)
    func unsubscribeChannel()
    
    func performFetch(delegate: NSFetchedResultsControllerDelegate)
    func fetchMessages() -> [MessageModel]?
    func fetchMessage(at indexPath: IndexPath) -> MessageModel?
}

class ConversationViewInteractor: ConversationViewBusinessLogic {
    weak var viewController: ConversationViewDisplayLogic?
    var channel: ChannelModel?
    
    
    let messagesService: MessagesServiceProtocol
    let messagesRepository: MessageRepositoryProtocol
    
    init(messagesService: MessagesServiceProtocol,
         messagesRepository: MessageRepositoryProtocol) {
        self.messagesService = messagesService
        self.messagesRepository = messagesRepository
    }
    
    func send(_ message: String) {
        guard let channel = channel else { return }
        
        messagesService.send(message, to: channel.identifier)
    }
    
    func listenMessagesChanges() {
        guard let channel = channel else { return }
        
        messagesService.subscribeMessagesUpdating(in: channel.identifier) { [weak self] in
            DispatchQueue.main.async {
                self?.viewController?.messagesLoaded()
            }
            
        }
    }
    
    func unsubscribeChannel() {
        messagesService.removeListenerMessages()
    }
    
    func performFetch(delegate: NSFetchedResultsControllerDelegate) {
        messagesRepository.setFetchedResultsController(delegate: delegate)
    }
    
    func fetchMessages() -> [MessageModel]? {
        messagesRepository.fetchedObjects()
    }
    
    func fetchMessage(at indexPath: IndexPath) -> MessageModel? {
        messagesRepository.object(at: indexPath)
    }
}
