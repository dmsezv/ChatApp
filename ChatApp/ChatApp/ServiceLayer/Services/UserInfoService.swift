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
    func saveInfo(_ model: UserInfoModel, _ complete: @escaping () -> Void,
                  fail: @escaping(_ message: String) -> Void)
}

class UserInfoService: UserInfoServiceProtocol {
    private let userInfoManager: UserInfoManagerProtocol
    
    init(userInfoManager: UserInfoManagerProtocol) {
        self.userInfoManager = userInfoManager
    }
    
    var senderId: String {
        userInfoManager.fetchSenderId()
    }
    var senderName: String {
        userInfoManager.fetchSenderName()
    }
    
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
    
    func saveInfo(_ model: UserInfoModel, _ complete: @escaping () -> Void,
                  fail: @escaping(_ message: String) -> Void) {
        userInfoManager.saveInfo(model) { (result) in
            switch result {
            case .success:
                complete()
            case .failure(let error):
                var message = ""
                
                switch error {
                case .encodingError:
                    message = "Не удалось кодировать модели"
                default:
                    message = "Не удалось сохраненить данные"
                }
                
                fail(message)
            }
        }
    }
}
