//
//  ChannelRepository.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import Foundation

protocol ChannelRepositoryProtocol {
    func fetchObject(by indexPath: IndexPath) -> ChannelModel?
    func fetchObjects() -> [ChannelModel]?
}

class ChannelRepository: ChannelRepositoryProtocol {
    func fetchObject(by indexPath: IndexPath) -> ChannelModel? {
        return nil
    }
    
    func fetchObjects() -> [ChannelModel]? {
        return nil
    }
}
