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
}

class ProfileInteractor: ProfileBusinessLogic {
    weak var viewController: ProfileDisplayLogic?
    
    func fetchUserInfoBy(_ type: UserInfoSaverType) {
        var saver: UserInfoSaver
        
        switch type {
        case .gcd:
            saver = UserInfoSaverGCD()
        case .operation:
            saver = UserInfoSaverOperation()
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
        var saver: UserInfoSaver
        
        switch type {
        case .gcd:
            saver = UserInfoSaverGCD()
        case .operation:
            saver = UserInfoSaverOperation()
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
}
