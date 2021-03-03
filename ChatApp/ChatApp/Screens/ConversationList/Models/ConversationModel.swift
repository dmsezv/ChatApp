//
//  Conversation.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 02.03.2021.
//

import Foundation

protocol ConversationCellConfiguration: class {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationModel: ConversationCellConfiguration {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    
    init(name: String? = nil, message: String? = nil, date: Date? = nil, online: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
    
    static func mockConversations() -> [ConversationCellConfiguration] {
        return [
            ConversationModel(
                name: "Kirill",
                message: "Hello world",
                date: Date(),
                online: true,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSinceReferenceDate: -123456789.0),
                online: true,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Masha",
                message: "Hello world",
                date: Date(timeIntervalSinceReferenceDate: -123123123.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Sasha",
                message: "Hello world",
                date: Date(),
                online: false,
                hasUnreadMessages: false)
        ]
    }
    
    static func mockConversationsHistory() -> [ConversationCellConfiguration] {
        return [
            ConversationModel(
                name: "Kirill",
                message: "Hello world",
                date: Date(timeIntervalSinceReferenceDate: -123123123.0),
                online: true,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSinceReferenceDate: -123456100.0),
                online: true,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Masha",
                message: "Hello world",
                date: Date(timeIntervalSinceReferenceDate: -123456200.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Sasha",
                message: "Hello world",
                date: Date(timeIntervalSinceReferenceDate: -123456444.0),
                online: false,
                hasUnreadMessages: false)
        ]
    }
}
