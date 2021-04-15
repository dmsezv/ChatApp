//
//  UserInfoService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import Foundation

protocol UserInfoServiceProtocol {
    var senderId: String { get }
    var senderName: String { get }
}

class UserInfoService: UserInfoServiceProtocol {
    private let userInfoManager: UserInfoManagerProtocol
    
    init(userInfoManager: UserInfoManagerProtocol) {
        self.userInfoManager = userInfoManager
        
        senderId = userInfoManager.fetchSenderId()
        senderName = userInfoManager.fetchSenderName()
    }
    
    var senderId: String
    var senderName: String
}
