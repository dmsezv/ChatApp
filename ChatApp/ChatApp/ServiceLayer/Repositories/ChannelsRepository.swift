//
//  FetchedResultChannelsService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 16.04.2021.
//

import Foundation

protocol ChannelRepositoryProtocol {
    func object(at indexPath: IndexPath) -> ChannelModel?
    func fetchedObjects() -> [ChannelModel]?
}

class ChannelRepository: FetchedResultService<ChannelDB>, ChannelRepositoryProtocol {
    func object(at indexPath: IndexPath) -> ChannelModel? {
        let channelDB = super.object(at: indexPath)
        return ChannelModel.createFrom(channelDB)
    }
    
    func fetchedObjects() -> [ChannelModel]? {
        guard let channels = super.fetchedObjects() else { return nil }
        return channels.compactMap { ChannelModel.createFrom($0) }
    }
}
