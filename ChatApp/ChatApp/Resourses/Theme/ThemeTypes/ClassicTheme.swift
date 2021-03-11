//
//  ClassicTheme.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit

struct ClassicTheme: ThemeProtocol {
    var typeTheme: ThemePicker.ThemeType = .classic
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var userInterfaceStyle: UIUserInterfaceStyle = .light
    var statusBarStyle: UIStatusBarStyle = .default
}
