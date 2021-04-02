//
//  ConversationViewInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 24.03.2021.
//

import Foundation
import Firebase

protocol ConversationViewBusinessLogic {
    func getMessages()
    func send(_ message: String)
    func unsubscribeChannel()
    
    var channel: ChannelModel? { get set }
}

class ConversationViewInteractor: ConversationViewBusinessLogic {
    weak var viewController: ConversationViewDisplayLogic?
    var channel: ChannelModel?
    
    private lazy var firebaseService = FirebaseService.shared
    private lazy var userInfoGCD = UserInfoSaverGCD()
    private lazy var senderId: String = userInfoGCD.fetchSenderId()
    private var senderName: String = ""
    
    func getMessages() {
        guard let channel = channel else {
            return
        }
        
        firebaseService.listenMessageList(in: channel.identifier) { [weak self] messages in
            guard let messages = messages else { return }
            
            DispatchQueue.main.async {
                self?.viewController?.displayList(messages)
            }
        }
    }
    
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
                        // TODO: после сдачи поменять на деволт
                        self?.senderName = "Dmitrii Zverev"
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
                                           "created": Timestamp(date: Date()),
                                           "senderName": senderName,
                                           "senderId": senderId], to: id)
    }
    
    func unsubscribeChannel() {
        firebaseService.removeListenerMessages()
    }
}

// MARK: - Core Data

extension ConversationViewInteractor {
    private func saveInCoreData(_ messages: [MessageModel]) {
        guard let channel = channel else {
            return
        }
        
        CoreDataStack.shared.performSave { (context) in
            let messagesDB: [MessageDB] = messages.compactMap { msg in
                return MessageDB(message: msg, in: context)
            }
            
            let chn = ChannelDB(channel: channel, in: context)
            messagesDB.forEach { chn.addToMessages($0) }
        }
    }
}
