//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import Foundation

protocol CoreAssemblyProtocol {
    func coreDataStack() -> CoreDataStackProtocol
    func userInfoDataManager(_ type: UserInfoSaverType) -> UserInfoSaver
}

class CoreAssembly: CoreAssemblyProtocol {
    func coreDataStack() -> CoreDataStackProtocol {
        return CoreDataStack.shared
    }
    
    func userInfoDataManager(_ type: UserInfoSaverType) -> UserInfoSaver {
        switch type {
        case .gcd:
            return UserInfoSaverGCD()
        case .operation:
            return UserInfoSaverOperation()
        }
        
    }
}
