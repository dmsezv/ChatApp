//
//  ConversationListModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import Foundation

enum ConversationList {
    struct Response {
        var conversationList: [ChannelModel]?
        var isError: Bool
        var message: String?
    }
    
    struct ViewModel {
        struct DispalyedChannels {
            var id: String
            var name: String
            var lastMessage: String?
            var lastActivity: String?
        }
        
        var displayedChannels: [DispalyedChannels]
    }
}
