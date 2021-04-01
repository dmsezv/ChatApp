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
    func routeToShowChat(title: String?, identifierChannel: String)
    func routeToMessagesIn(_ channel: ChannelModel)
}

class ConversationListRouter: ConversationListRoutingLogic {
    weak var viewController: ConversationsListViewController?
    
    func routeToProfile() {
        let SB = UIStoryboard(name: "Profile", bundle: nil)
        if let destinationVC = SB.instantiateInitialViewController() as? ProfileViewController {
            destinationVC.delegateViewController = viewController
            viewController?.present(destinationVC, animated: true)
        }
    }
    
    func routeToShowChat(title: String?, identifierChannel: String) {
        if let destinationVC = viewController?
            .storyboard?
            .instantiateViewController(withIdentifier: String(describing: ConversationViewController.self)) as? ConversationViewController {
            
            destinationVC.title = title ?? "Unknown user"
            destinationVC.identifierChannel = identifierChannel
            //destinationVC.interactor?.channel =
            viewController?.show(destinationVC, sender: nil)
        }
    }
    
    func routeToMessagesIn(_ channel: ChannelModel) {
        if let destinationVC = viewController?
            .storyboard?
            .instantiateViewController(withIdentifier: String(describing: ConversationViewController.self)) as? ConversationViewController,
           let _ = destinationVC.interactor {
            
            destinationVC.title = channel.name
            destinationVC.interactor?.channel = channel
            viewController?.show(destinationVC, sender: nil)
        }
    }
    
    func routeToSettings() {
        let SB = UIStoryboard(name: "ThemesSetting", bundle: nil)
        if let destinationVC = SB.instantiateInitialViewController() as? ThemesViewController {
            destinationVC.themePickerDelegate = ThemePicker.shared
            destinationVC.themePickerCallback = ThemePicker.shared.callbackChangeTheme

            viewController?.show(destinationVC, sender: nil)
        }
    }
}
