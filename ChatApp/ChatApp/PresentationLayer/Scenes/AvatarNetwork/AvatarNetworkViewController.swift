//
//  AvatarNetwork.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 19.04.2021.
//

import UIKit

protocol AvatarNetworkViewControllerDisplayLogic: class {
    
}

class AvatarNetworkViewController: UIViewController {
    
    var interactor: AvatarNetworkInteractor?
    
    // MARK: - IBOutlets
    
    @IBAction func touchButtonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Display Logic

extension AvatarNetworkViewController: AvatarNetworkViewControllerDisplayLogic {
    
}
