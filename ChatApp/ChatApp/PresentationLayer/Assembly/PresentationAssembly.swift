//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import UIKit

protocol PresentationAssemblyProtocol {
    func conversationListViewController() -> ConversationsListViewController?
    func conversationListNavigationController(rootViewController: ConversationsListViewController) -> ConversationListNavigationController
    func profileViewController() -> ProfileViewController?
}

class PresentationAssembly: PresentationAssemblyProtocol {
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationListViewController() -> ConversationsListViewController? {
        let viewController = UIStoryboard(name: "Conversation", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: ConversationsListViewController.self)) as? ConversationsListViewController
        let router = ConversationListRouter(presentationAssembly: self)
        let interactor = ConversationListInteractor(firebaseService: serviceAssembly.firebaseChannelsService())
        viewController?.router = router
        viewController?.interactor = interactor
        router.viewController = viewController
        interactor.viewController = viewController
        
        return viewController
    }
    
    func conversationListNavigationController(rootViewController: ConversationsListViewController) -> ConversationListNavigationController {
        ConversationListNavigationController(rootViewController: rootViewController)
    }
    
    func profileViewController() -> ProfileViewController? {
        UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as? ProfileViewController
    }
}
