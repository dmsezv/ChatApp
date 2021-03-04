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
}


//MARK: - Mock Data

extension ConversationModel {
    static func mockConversationsOnline() -> [ConversationCellConfiguration] {
        return [
            ConversationModel(
                name: "Kirill",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: true,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1583325658.0),
                online: true,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Masha",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Sasha",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: "Artem",
                message: "Are ye aware, that he who comes behind Moves what he touches?  The feet of the dead Are not so wont.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: true,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1546432858.0),
                online: true,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Oleg",
                message: "Return, and be their guide. And if ye chance to cross another troop, Command them keep aloof.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Dima",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: "Anita",
                message: "Return, and be their guide. And if ye chance to cross another troop, Command them keep aloof.",
                date: Date(),
                online: true,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1559479258.0),
                online: true,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Sahar",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(timeIntervalSince1970: 1603111258.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Semen",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(),
                online: false,
                hasUnreadMessages: false)
        ]
    }
    static func mockConversationsHistory() -> [ConversationCellConfiguration] {
        return [
            ConversationModel(
                name: "Kirill",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1583325658.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Masha",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Sasha",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: "Artem",
                message: "Are ye aware, that he who comes behind Moves what he touches?  The feet of the dead Are not so wont.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1546432858.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Oleg",
                message: "Return, and be their guide. And if ye chance to cross another troop, Command them keep aloof.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Dima",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: "Anita",
                message: "Return, and be their guide. And if ye chance to cross another troop, Command them keep aloof.",
                date: Date(),
                online: true,
                hasUnreadMessages: false),
            
            ConversationModel(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1559479258.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Sahar",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(timeIntervalSince1970: 1603111258.0),
                online: false,
                hasUnreadMessages: true),
            
            ConversationModel(
                name: "Semen",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(),
                online: false,
                hasUnreadMessages: false)
        ]
    }
}
