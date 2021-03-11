//
//  DarkTheme.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit

struct NightTheme: ThemeProtocol {
    var typeTheme: ThemePicker.ThemeType = .night
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .white
    var userInterfaceStyle: UIUserInterfaceStyle = .dark
    var statusBarStyle: UIStatusBarStyle = .lightContent
}
