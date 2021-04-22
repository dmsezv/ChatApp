//
//  ProfileInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 18.03.2021.
//

import Foundation

protocol ProfileBusinessLogic {
    func fetchUserInfo()
    func save(userInfo: UserInfoModel)
    func cancel()
}

class ProfileInteractor: ProfileBusinessLogic {
    weak var viewController: ProfileDisplayLogic?
    
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
    
    func save(userInfo: UserInfoModel) {
        userInfoService.saveInfo(userInfo) {
            DispatchQueue.main.async {
                self.viewController?.successSavedUserInfo()
            }
        } fail: { message in
            DispatchQueue.main.async {
                self.viewController?.errorDisplay(message)
            }
        }
    }
    
    func cancel() {
        userInfoService.cancelSaving()
    }
}
