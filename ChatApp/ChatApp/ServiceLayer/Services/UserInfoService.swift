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
    
    func fetchInfo(_ complete: @escaping (UserInfoModel?) -> Void,
                   fail: @escaping(_ message: String) -> Void)
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
    
    func fetchInfo(_ complete: @escaping (UserInfoModel?) -> Void,
                   fail: @escaping(_ message: String) -> Void) {
        userInfoManager.fetchInfo { result in
            switch result {
            case .success(let model):
                complete(model)
            case .failure(let error):
                var message = ""
                
                switch error {
                case .decodingError:
                    message = "Не удалось декодировать модели"
                default:
                    message = "Не удалось выгрузить данные"
                }
                
                fail(message)
            }
        }
    }
}
