//
//  ConversationListInteractor.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 22.03.2021.
//

import Firebase
import CoreData

protocol ConversationListBusinessLogic {
    func listenChannelChanges()
    func createChannel(_ name: String?)
    func deleteChannel(_ identifier: String)
    func fetchSenderName() -> String
    
    func performFetch(delegate: NSFetchedResultsControllerDelegate)
    func fetchChannels() -> [ChannelModel]?
    func fetchChannel(at indexPath: IndexPath) -> ChannelModel?
}

class ConversationListInteractor: ConversationListBusinessLogic {
    weak var viewController: ConversationListDisplayLogic?
        
    let channelsRepository: ChannelRepositoryProtocol
    let channelsService: ChannelsServiceProtocol
    let userInfoService: UserInfoServiceProtocol
    
    init(channelsService: ChannelsServiceProtocol,
         userInfoService: UserInfoServiceProtocol,
         channelsRepository: ChannelRepositoryProtocol) {
        self.channelsService = channelsService
        self.userInfoService = userInfoService
        self.channelsRepository = channelsRepository
    }
    
    func listenChannelChanges() {
        channelsService.subscribeChannelsUpdating { [weak self] in
            DispatchQueue.main.async {
                self?.viewController?.channelsLoaded()
            }
        }
    }
    
    func createChannel(_ name: String?) {
        if let name = name, !name.isEmpty {
            channelsService.createChannel(name)
        } else {
            DispatchQueue.main.async {
                self.viewController?.displayError("The channel name should not be empty")
            }
        }
    }
    
    func deleteChannel(_ identifier: String) {
        channelsService.deleteChannel(identifier)
    }
    
    func fetchSenderName() -> String {
        userInfoService.senderName
        
    }
    
    func performFetch(delegate: NSFetchedResultsControllerDelegate) {
        channelsRepository.setFetchedResultsController(delegate: delegate)
        channelsRepository.performFetch { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.viewController?.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchChannels() -> [ChannelModel]? {
        channelsRepository.fetchedObjects()
    }
    
    func fetchChannel(at indexPath: IndexPath) -> ChannelModel? {
        channelsRepository.object(at: indexPath)
    }
}
