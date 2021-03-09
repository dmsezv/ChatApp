//
//  ConversattionListRouter.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 09.03.2021.
//

import UIKit

protocol ConversationListRoutingLogic {
    func routeToProfile()
    func routeToShowChat()
}

class ConversationListRouter: ConversationListRoutingLogic {
    weak var viewController: ConversationsListViewController?
    
    func routeToProfile() {
        let SB = UIStoryboard(name: "Profile", bundle: nil)
        if let destinationController = SB.instantiateInitialViewController() as? ProfileViewController {
            viewController?.present(destinationController, animated: true)
        }
    }
    
    func routeToShowChat() {
        
    }
}
