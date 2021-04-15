//
//  ProfileInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 18.03.2021.
//

import Foundation

protocol ProfileBusinessLogic {
    func fetchUserInfo()
    func save(userInfo: UserInfoModel, by type: UserInfoSaverType)
    func cancel()
}

class ProfileInteractor: ProfileBusinessLogic {
    weak var viewController: ProfileDisplayLogic?
    private lazy var userInfoOperation = UserInfoSaverOperation()
    private lazy var userInfoGCD = UserInfoSaverGCD()
    
    let userInfoService: UserInfoServiceProtocol
    
    init(userInfoService: UserInfoServiceProtocol) {
        self.userInfoService = userInfoService
    }
    
    func fetchUserInfo() {
        userInfoService.fetchInfo { userInfoModel in
            DispatchQueue.main.async {
                self.viewController?.successFetch(userInfoModel)
            }
        } fail: { message in
            DispatchQueue.main.async {
                self.viewController?.errorDisplay(message)
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
