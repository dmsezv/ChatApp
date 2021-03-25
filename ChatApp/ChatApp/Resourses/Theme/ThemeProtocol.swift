//
//  Theme.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit

protocol ThemeProtocol {
    
    // MARK: - Main Colors
    var typeTheme: ThemePicker.ThemeType { get }
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var userInterfaceStyle: UIUserInterfaceStyle { get }
    var statusBarStyle: UIStatusBarStyle { get }
    
    // MARK: - Message Cells
    var cellOutgoingBackground: UIColor { get }
    var cellIncomingBackground: UIColor { get }
    var cellOutgoingTextColor: UIColor { get }
    var cellIncomingTextColor: UIColor { get }
}
