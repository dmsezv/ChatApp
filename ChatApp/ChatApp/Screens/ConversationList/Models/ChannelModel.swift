//
//  ChannelModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 24.03.2021.
//

import Foundation

struct ChannelModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    static func createFrom(_ channelDB: ChannelDB) -> ChannelModel? {
        guard let idntf = channelDB.identifier,
              let name = channelDB.name else {
            return nil
        }
        
        return ChannelModel(
            identifier: idntf,
            name: name,
            lastMessage: channelDB.lastMessage,
            lastActivity: channelDB.lastActivity)
    }
}
