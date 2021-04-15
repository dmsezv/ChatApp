//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import Foundation

protocol ServiceAssemblyProtocol {
    func channelRepository() -> ChannelRepositoryProtocol
    func firebaseMessagesService() -> FirebaseMessagesServiceProtocol
    func firebaseChannelsService() -> FirebaseServiceChannelsProtocol
}

class ServiceAssembly: ServiceAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    func channelRepository() -> ChannelRepositoryProtocol {
        return ChannelRepository()
    }
    
    func firebaseMessagesService() -> FirebaseMessagesServiceProtocol {
        return FirebaseService(userInfoDataManager: coreAssembly.userInfoDataManager(.gcd),
                               coreDataStack: coreAssembly.coreDataStack())
    }
    
    func firebaseChannelsService() -> FirebaseServiceChannelsProtocol {
        return FirebaseService(userInfoDataManager: coreAssembly.userInfoDataManager(.gcd),
                               coreDataStack: coreAssembly.coreDataStack())
    }
}
