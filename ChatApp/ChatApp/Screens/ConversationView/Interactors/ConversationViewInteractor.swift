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
    func getMessagesFrom(_ identifierChannel: String)
    func send(_ message: String, to identifierChannel: String)
    func unsubscribeChannel()
    
    var channel: ChannelModel? { get set }
}

class ConversationViewInteractor: ConversationViewBusinessLogic {
    weak var viewController: ConversationViewDisplayLogic?
    var channel: ChannelModel?
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    private var listenerMessages: ListenerRegistration?
    private lazy var userInfoGCD = UserInfoSaverGCD()
    private lazy var senderId: String = userInfoGCD.fetchSenderId()
    private var senderName: String = ""

    func getMessagesFrom(_ identifierChannel: String) {
        listenerMessages = reference.document(identifierChannel).collection("messages").addSnapshotListener { [weak self] snapshot, _ in
            guard let snapshot = snapshot else { return }
            let messages = snapshot.documents.compactMap { document -> MessageModel? in
                guard let content = document["content"] as? String,
                      !content.isEmpty,
                      let created = (document["created"] as? Timestamp)?.dateValue(),
                      let senderId = document["senderId"] as? String,
                      !senderId.isEmpty,
                      let senderName = document["senderName"] as? String,
                      !senderName.isEmpty,
                      !document.documentID.isEmpty
                else { return nil }
                
                return MessageModel(
                    identifier: document.documentID,
                    content: content,
                    created: created,
                    senderId: senderId,
                    senderName: senderName)
            }.sorted(by: { (prev, next) -> Bool in
                prev.created < next.created
            })
            
            DispatchQueue.main.async {
                self?.viewController?.displayList(messages)
            }
        }
    }
    
    func getMessages() {
        guard let channel = channel else {
            return
        }
        
        listenerMessages = reference.document(channel.identifier).collection("messages").addSnapshotListener { [weak self] snapshot, _ in
            guard let snapshot = snapshot else { return }
            let messages = snapshot.documents.compactMap { document -> MessageModel? in
                guard let content = document["content"] as? String,
                      !content.isEmpty,
                      let created = (document["created"] as? Timestamp)?.dateValue(),
                      let senderId = document["senderId"] as? String,
                      !senderId.isEmpty,
                      let senderName = document["senderName"] as? String,
                      !senderName.isEmpty,
                      !document.documentID.isEmpty
                else { return nil }
                
                return MessageModel(
                    identifier: document.documentID,
                    content: content,
                    created: created,
                    senderId: senderId,
                    senderName: senderName)
            }.sorted(by: { (prev, next) -> Bool in
                prev.created < next.created
            })
            
            self?.saveInCoreData(messages)
            
            DispatchQueue.main.async {
                self?.viewController?.displayList(messages)
            }
        }
    }
    
    func send(_ message: String, to identifierChannel: String) {
        if senderName.isEmpty {
            userInfoGCD.fetchInfo { [self] (result) in
                switch result {
                // TODO: нужна логика обработки неудачи вытаскивания userInfo
                // пока оставляю так, по текущей задаче ее отсутствие не критично
                case .success(let userInfo):
                    if let name = userInfo?.name, !name.isEmpty {
                        self.senderName = name
                    } else {
                        // TODO: после сдачи поменять на деволт
                        self.senderName = "Dmitrii Zverev"
                    }
                case .failure:
                    break
                }
                
                self.sendMessageToChannel(message, identifierChannel)
            }
        } else {
            sendMessageToChannel(message, identifierChannel)
        }
    }
    
    private func sendMessageToChannel(_ message: String, _ id: String) {
        reference.document(id).collection("messages")
            .addDocument(data: ["content": message,
                                "created": Timestamp(date: Date()),
                                "senderName": senderName,
                                "senderId": senderId])
    }
    
    func unsubscribeChannel() {
        listenerMessages?.remove()
    }
}

// MARK: - Core Data

extension ConversationViewInteractor {
    private func saveInCoreData(_ messages: [MessageModel]) {
        guard let channel = channel else {
            return
        }
        
        DispatchQueue.global().async {
            CoreDataStack.shared.performSave { (context) in
                let chn = ChannelDB(channel: channel, in: context)
                messages.forEach { chn.addToMessages(MessageDB(message: $0, in: context)) }
            }
        }
    }
}
