//
//  DataProvider.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 04.03.2021.
//

import Foundation

struct DataProvider {
    
    static func getMockConversationsHistory() -> [ConversationModel] {
        return [
            .init(
                name: "Kirill",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            .init(
                name: "Masha",
                message: "Hello",
                date: Date(timeIntervalSince1970: 1583325658.0),
                online: false,
                hasUnreadMessages: true),
            
            .init(
                name: "Masha",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            .init(
                name: "Sasha",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            .init(
                name: "Artem",
                message: "Are ye aware, that he who comes behind Moves what he touches?  The feet of the dead Are not so wont.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: false),
            
            .init(
                name: "Oleg",
                message: "Return, and be their guide. And if ye chance to cross another troop, Command them keep aloof.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            .init(
                name: "Dima",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            .init(
                name: "Anita",
                message: "Return, and be their guide. And if ye chance to cross another troop, Command them keep aloof.",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            .init(
                name: "Sahar",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(timeIntervalSince1970: 1603111258.0),
                online: false,
                hasUnreadMessages: true),
            
            .init(
                name: "Semen",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(),
                online: false,
                hasUnreadMessages: false)
        ]
    }
    
    static func getMockConversationsOnline() -> [ConversationModel] {
        return [
            .init(
                name: "Kirill",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: true,
                hasUnreadMessages: false),
            
            .init(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1583325658.0),
                online: true,
                hasUnreadMessages: true),
            
            .init(
                name: "Masha",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            .init(
                name: "Sasha",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            .init(
                name: "Artem",
                message: "Are ye aware, that he who comes behind Moves what he touches?  The feet of the dead Are not so wont.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: true,
                hasUnreadMessages: false),
            
            .init(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1546432858.0),
                online: true,
                hasUnreadMessages: true),
            
            .init(
                name: "Oleg",
                message: "Return, and be their guide. And if ye chance to cross another troop, Command them keep aloof.",
                date: Date(timeIntervalSince1970: 1578141658.0),
                online: false,
                hasUnreadMessages: true),
            
            .init(
                name: "Dima",
                message: "Perchance thou deem'st The King of Athens here, who, in the world Above, thy death contriv'd.  Monster! avaunt! He comes not tutor'd by thy sister's art, But to behold your torments is he come.",
                date: Date(),
                online: false,
                hasUnreadMessages: false),
            
            .init(
                name: "Anita",
                message: nil,
                date: Date(),
                online: true,
                hasUnreadMessages: false),
            
            .init(
                name: nil,
                message: nil,
                date: Date(timeIntervalSince1970: 1559479258.0),
                online: true,
                hasUnreadMessages: true),
            
            .init(
                name: "Sahar",
                message: "Our answer shall be made To Chiron, there, when nearer him we come. Ill was thy mind, thus ever quick and rash",
                date: Date(timeIntervalSince1970: 1603111258.0),
                online: false,
                hasUnreadMessages: true),
            
            .init(
                name: "Semen",
                message: "Know then, that when I erst Hither descended to the nether hell, This rock was not yet fallen",
                date: Date(),
                online: false,
                hasUnreadMessages: false)
        ]
    }

    static func getMockMessages() -> [MessageModel] {
        return [
            .init(text: "Ты тупой идиот. Приходи сегодня на репу.",
                  isIncoming: true),
            .init(text: "Чо?",
                  isIncoming: false),
            .init(text: "Мы сегодня не договаривались",
                  isIncoming: false),
            .init(text: "Да и голова ужасно после вчерашнего болит ",
                  isIncoming: false),
            .init(text: "Будет еще сильнее болеть, когда мы об нее твою басуху разобьем",
                  isIncoming: true),
            .init(text: "что случилось то?",
                  isIncoming: false),
            .init(text: "Ничего не помнишь?",
                  isIncoming: true),
            .init(text: "Ты на барабанах (на каждом) написал маркером \"йа барабанчег\". Да еще так крупно, что теперь все будут думать, что так называется наша группа",
                  isIncoming: true),
            .init(text: "И на гитаре \"йа гитарко\"",
                  isIncoming: true),
            .init(text: "Йа кросавчег)))",
                  isIncoming: false),
            .init(text: "Вот значит почему Витек мне смску прислал \"ты труп\"",
                  isIncoming: false),
            .init(text: "Нет, не по этому",
                  isIncoming: true),
            .init(text: "Мы все утро с анькиного лба \"йа тёлко\" оттирали",
                  isIncoming: true),
            .init(text: "жесть",
                  isIncoming: false),
            .init(text: "Йа идиот",
              isIncoming: false),
        ]
    }
}
