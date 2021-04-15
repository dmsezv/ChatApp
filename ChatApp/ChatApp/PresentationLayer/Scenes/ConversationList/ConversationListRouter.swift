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
    
    let presentationAssembly: PresentationAssemblyProtocol?
    
    init(presentationAssembly: PresentationAssemblyProtocol) {
        self.presentationAssembly = presentationAssembly
    }
    
    func routeToProfile() {
        if let profileVC = presentationAssembly?.profileViewController() {
            profileVC.delegateViewController = viewController
            viewController?.present(profileVC, animated: true)
        }
    }
    
    func routeToMessagesIn(_ channel: ChannelModel) {
        if let destinationVC = viewController?
            .storyboard?
            .instantiateViewController(withIdentifier: String(describing: ConversationViewController.self)) as? ConversationViewController {
            
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
