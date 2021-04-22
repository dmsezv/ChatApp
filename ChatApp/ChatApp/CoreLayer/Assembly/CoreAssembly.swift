//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import Foundation

protocol CoreAssemblyProtocol {
    func coreDataStack() -> CoreDataStackProtocol
    func userInfoDataManager(_ type: UserInfoSaverType) -> UserInfoManagerProtocol
    func firebaseManager() -> FirebaseManagerProtocol
    func networkManager() -> NetworkManagerProtocol
}

class CoreAssembly: CoreAssemblyProtocol {
    func coreDataStack() -> CoreDataStackProtocol {
        return CoreDataStack.shared
    }
    
    func userInfoDataManager(_ type: UserInfoSaverType) -> UserInfoManagerProtocol {
        switch type {
        case .gcd:
            return UserInfoSaverGCD()
        case .operation:
            return UserInfoSaverOperation()
        }
        
    }
    
    func firebaseManager() -> FirebaseManagerProtocol {
        return FirebaseManager.shared
    }
    
    func networkManager() -> NetworkManagerProtocol {
        return NetworkManager()
    }
}
