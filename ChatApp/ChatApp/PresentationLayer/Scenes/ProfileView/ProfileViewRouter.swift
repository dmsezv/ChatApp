//
//  ProfileViewRouter.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 19.04.2021.
//

import Foundation

protocol ProfileViewRoutingLogic {
    func routeToAvatarNetwork()
}

class ProfileViewRouter: ProfileViewRoutingLogic {
    weak var viewController: ProfileViewController?
    
    private let presentationAssembly: PresentationAssemblyProtocol
    
    init(presentationAssembly: PresentationAssemblyProtocol) {
        self.presentationAssembly = presentationAssembly
    }
    
    func routeToAvatarNetwork() {
        if let avatarNetworkVC = presentationAssembly.avatarNetworkViewController() {
            avatarNetworkVC.delegate = viewController
            viewController?.present(avatarNetworkVC, animated: true, completion: nil)
        }
    }
}
