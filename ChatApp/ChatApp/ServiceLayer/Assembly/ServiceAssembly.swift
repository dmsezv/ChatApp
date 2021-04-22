//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import Foundation

protocol ServiceAssemblyProtocol {
    func channelsService() -> ChannelsServiceProtocol
    func messagesServices() -> MessagesServiceProtocol
    func userInfoService() -> UserInfoServiceProtocol
    func pixabayService() -> PixabayServiceProtocol
}

class ServiceAssembly: ServiceAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    func channelsService() -> ChannelsServiceProtocol {
        return ChannelsService(
            coreDataStack: coreAssembly.coreDataStack(),
            firebaseManager: coreAssembly.firebaseManager()
        )
    }
    
    func messagesServices() -> MessagesServiceProtocol {
        return MessagesService(
            coreDataStack: coreAssembly.coreDataStack(),
            firebaseManager: coreAssembly.firebaseManager(),
            userInfoDataManager: coreAssembly.userInfoDataManager(.gcd)
        )
    }
    
    func userInfoService() -> UserInfoServiceProtocol {
        return UserInfoService(userInfoManager: coreAssembly.userInfoDataManager(.gcd))
    }
    
    func pixabayService() -> PixabayServiceProtocol {
        return PixabayService(networkManager: coreAssembly.networkManager())
    }
}
