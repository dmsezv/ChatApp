//
//  ConversattionListRouter.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 09.03.2021.
//

import UIKit

protocol ConversationListRoutingLogic {
    func routeToProfile()
    func routeToSettings()
    func routeToMessagesIn(_ channel: ChannelModel)
}

class ConversationListRouter: ConversationListRoutingLogic {
    weak var viewController: ConversationsListViewController?
    
    let presentationAssembly: PresentationAssemblyProtocol
    
    init(presentationAssembly: PresentationAssemblyProtocol) {
        self.presentationAssembly = presentationAssembly
    }
    
    func routeToProfile() {
        if let profileVC = presentationAssembly.profileViewController(delegate: viewController) {
            viewController?.present(profileVC, animated: true)
        }
    }
    
    func routeToMessagesIn(_ channel: ChannelModel) {
        if let conversationVC = presentationAssembly.conversationViewController(channel: channel) {
            viewController?.show(conversationVC, sender: nil)
        }
    }
    
    func routeToSettings() {
        if let themesVC = presentationAssembly.themesViewController() {
            viewController?.show(themesVC, sender: nil)
        }
    }
}
