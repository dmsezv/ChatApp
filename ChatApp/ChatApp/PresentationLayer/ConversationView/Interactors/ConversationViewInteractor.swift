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
    
    private lazy var firebaseService = FirebaseService.shared
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var userInfoGCD = UserInfoSaverGCD()
    private lazy var senderId: String = userInfoGCD.fetchSenderId()
    private var senderName: String = ""
    
    func send(_ message: String) {
        guard let channel = channel else {
            return
        }
        
        if senderName.isEmpty {
            userInfoGCD.fetchInfo { [weak self] (result) in
                switch result {
                // TODO: нужна логика обработки неудачи вытаскивания userInfo
                // пока оставляю так, по текущей задаче ее отсутствие не критично
                case .success(let userInfo):
                    if let name = userInfo?.name, !name.isEmpty {
                        self?.senderName = name
                    } else {
                        self?.senderName = "Undefined"
                    }
                case .failure:
                    break
                }
                
                self?.sendMessageToChannel(message, channel.identifier)
            }
        } else {
            sendMessageToChannel(message, channel.identifier)
        }
    }
    
    private func sendMessageToChannel(_ message: String, _ id: String) {
        firebaseService.addDocument(data: ["content": message,
                                           "created": Timestamp(date: Date()) as? String,
                                           "senderName": senderName,
                                           "senderId": senderId], to: id)
    }
    
    func listenMessagesChanges() {
        guard let channel = channel else {
            return
        }
        
        firebaseService.listenChangesMessageList(in: channel.identifier) { [weak self] documentChanges in
            if let documentChanges = documentChanges {
                self?.coreDataStack.updateInCoreData(messageListChanges: documentChanges, in: channel.identifier)
                DispatchQueue.main.async {
                    self?.viewController?.messagesLoaded()
                }
            }
        }
    }
    
    func unsubscribeChannel() {
        firebaseService.removeListenerMessages()
    }
}
