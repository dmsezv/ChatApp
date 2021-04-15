//
//  ProfileInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 18.03.2021.
//

import Foundation

protocol ProfileBusinessLogic {
    func fetchUserInfoBy(_ type: UserInfoSaverType)
    func save(userInfo: UserInfoModel, by type: UserInfoSaverType)
    func cancel()
}

class ProfileInteractor: ProfileBusinessLogic {
    weak var viewController: ProfileDisplayLogic?
    private lazy var userInfoOperation = UserInfoSaverOperation()
    private lazy var userInfoGCD = UserInfoSaverGCD()
    
    func fetchUserInfoBy(_ type: UserInfoSaverType) {
        var saver: UserInfoManagerProtocol
        
        switch type {
        case .gcd:
            saver = userInfoGCD
        case .operation:
            saver = userInfoOperation
        }
        
        saver.fetchInfo { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.viewController?.successFetch(model)
                case .failure(let error):
                    var message = ""
                    
                    switch error {
                    case .decodingError:
                        message = "Не удалось декодировать модели"
                    default:
                        message = "Не удалось выгрузить данные"
                    }
                    
                    self.viewController?.errorDisplay(message)
                }
            }
        }
    }
    
    func save(userInfo: UserInfoModel, by type: UserInfoSaverType) {
        var saver: UserInfoManagerProtocol
        
        switch type {
        case .gcd:
            saver = userInfoGCD
        case .operation:
            saver = userInfoOperation
        }
        
        saver.saveInfo(userInfo, complete: { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.viewController?.successSavedUserInfo()
                case .failure(let error):
                    var message = ""
                    
                    switch error {
                    case .encodingError:
                        message = "Не удалось кодировать модели"
                    default:
                        message = "Не удалось сохраненить данные"
                    }
                    
                    self.viewController?.errorDisplay(message)
                }
            }
        })
    }
    
    func cancel() {
        userInfoOperation.cancelSaving()
        userInfoGCD.cancelSaving()
    }
}
