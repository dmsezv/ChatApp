//
//  RepositoriesAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.04.2021.
//

import CoreData

protocol RepositoriesAssemblyProtocol {
    func channelRepository() -> ChannelRepositoryProtocol
}

class RepositoriesAssembly: RepositoriesAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }

    func channelRepository() -> ChannelRepositoryProtocol {
        let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "lastActivity", ascending: false),
            NSSortDescriptor(key: "name", ascending: false)
        ]
        request.resultType = .managedObjectResultType
        
        return ChannelRepository(
            coreDataStack: coreAssembly.coreDataStack(),
            fetchRequest: request
        )
    }
}
