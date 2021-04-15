//
//  RepositoriesAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.04.2021.
//

import CoreData

protocol RepositoriesAssemblyProtocol {
    func channelRepository() -> ChannelRepositoryProtocol
    func messageRepository(channelId: String) -> MessageRepositoryProtocol
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
    
    func messageRepository(channelId: String) -> MessageRepositoryProtocol {
        let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        request.predicate = NSPredicate(format: "channel.identifier == %@", channelId)
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        request.resultType = .managedObjectResultType
        
        return MessageRepository(
            coreDataStack: coreAssembly.coreDataStack(),
            fetchRequest: request)
    }
}
