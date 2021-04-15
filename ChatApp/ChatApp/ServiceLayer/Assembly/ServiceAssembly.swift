//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import Foundation

protocol ServiceAssemblyProtocol {
    func firebaseMessagesService() -> FirebaseMessagesServiceProtocol
    func channelsService() -> ChannelsServiceProtocol
}

class ServiceAssembly: ServiceAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    func channelsService() -> ChannelsServiceProtocol {
        return ChannelsService(
            coreDataStack: coreAssembly.coreDataStack(),
            firebaseManager: coreAssembly.firebaseManager())
    }
    
    func firebaseMessagesService() -> FirebaseMessagesServiceProtocol {
        return FirebaseService(userInfoDataManager: coreAssembly.userInfoDataManager(.gcd),
                               coreDataStack: coreAssembly.coreDataStack())
    }
}
