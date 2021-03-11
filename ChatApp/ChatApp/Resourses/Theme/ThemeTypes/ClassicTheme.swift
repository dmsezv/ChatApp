//
//  ClassicTheme.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit


struct ClassicTheme: ThemeProtocol {
    typealias MessageColor = UIColor.ChooseThemeButtonView.Classic
    
    var typeTheme: ThemePicker.ThemeType = .classic
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var userInterfaceStyle: UIUserInterfaceStyle = .light
    var statusBarStyle: UIStatusBarStyle = .default
    var cellOutgoingBackground: UIColor = MessageColor.rightViewColorGreen
    var cellIncomingBackground: UIColor = MessageColor.leftViewColorGray
    var cellOutgoingTextColor: UIColor = .black
    var cellIncomingTextColor: UIColor = .black
}
