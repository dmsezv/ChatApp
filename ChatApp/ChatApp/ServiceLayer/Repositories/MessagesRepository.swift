//
//  MessagesRepository.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.04.2021.
//

import CoreData

protocol MessageRepositoryProtocol {
    func setFetchedResultsController(delegate: NSFetchedResultsControllerDelegate?)
    func performFetch(_ errorHandler: (Error?) -> Void)
    func object(at indexPath: IndexPath) -> MessageModel?
    func fetchedObjects() -> [MessageModel]?
}

class MessageRepository: FetchedResultService<MessageDB>, MessageRepositoryProtocol {
    func object(at indexPath: IndexPath) -> MessageModel? {
        let messageDB = super.object(at: indexPath)
        return MessageModel.createFrom(messageDB)
    }
    
    func fetchedObjects() -> [MessageModel]? {
        guard let channels = super.fetchedObjects() else { return nil }
        return channels.compactMap { MessageModel.createFrom($0) }
    }
}
