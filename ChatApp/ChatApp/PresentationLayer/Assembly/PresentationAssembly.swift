//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import UIKit

protocol PresentationAssemblyProtocol {
    func conversationListViewController() -> ConversationsListViewController?
    func conversationViewController(channel: ChannelModel) -> ConversationViewController? 
    func conversationListNavigationController(rootViewController: ConversationsListViewController) -> ConversationListNavigationController
    func profileViewController(delegate: ConversationsListDelegate?) -> ProfileViewController?
    func themesViewController() -> ThemesViewController?
}

class PresentationAssembly: PresentationAssemblyProtocol {
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationViewController(channel: ChannelModel) -> ConversationViewController? {
        let viewController = UIStoryboard(name: "Conversation", bundle: nil)
        .instantiateViewController(withIdentifier: String(describing: ConversationViewController.self)) as? ConversationViewController
        let interactor = ConversationViewInteractor(messagesService: serviceAssembly.messagesServices())
        interactor.channel = channel
        viewController?.interactor = interactor
        interactor.viewController = viewController
        viewController?.title = channel.name
        
        return viewController
    }
    
    func conversationListViewController() -> ConversationsListViewController? {
        let viewController = UIStoryboard(name: "Conversation", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: ConversationsListViewController.self)) as? ConversationsListViewController
        let router = ConversationListRouter(presentationAssembly: self)
        let interactor = ConversationListInteractor(
            channelsService: serviceAssembly.channelsService(),
            userInfoService: serviceAssembly.userInfoService()
        )
        viewController?.router = router
        viewController?.interactor = interactor
        router.viewController = viewController
        interactor.viewController = viewController
        
        return viewController
    }
    
    func conversationListNavigationController(rootViewController: ConversationsListViewController) -> ConversationListNavigationController {
        ConversationListNavigationController(rootViewController: rootViewController)
    }
    
    func profileViewController(delegate: ConversationsListDelegate?) -> ProfileViewController? {
        let viewController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as? ProfileViewController
        viewController?.delegateViewController = delegate
        
        return viewController
    }
    
    //TODO: setvice theme.shared
    func themesViewController() -> ThemesViewController? {
        let viewController = UIStoryboard(name: "ThemesSetting", bundle: nil).instantiateInitialViewController() as? ThemesViewController
        viewController?.themePickerDelegate = ThemePicker.shared
        viewController?.themePickerCallback = ThemePicker.shared.callbackChangeTheme
        
        return viewController
    }
}
