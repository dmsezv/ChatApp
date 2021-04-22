//
//  ConversationListNavigationController.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit

class ConversationListNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        ThemePicker.shared.currentTheme.statusBarStyle
    }
}
