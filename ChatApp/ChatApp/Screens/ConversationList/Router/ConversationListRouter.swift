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
