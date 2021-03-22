//
//  DayTheme.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit

struct DayTheme: ThemeProtocol {
    typealias MessageColor = UIColor.ChooseThemeButtonView.Day
    
    var typeTheme: ThemePicker.ThemeType = .day
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var userInterfaceStyle: UIUserInterfaceStyle = .light
    var statusBarStyle: UIStatusBarStyle = .default
    var cellOutgoingBackground: UIColor = MessageColor.rightViewColorBlue
    var cellIncomingBackground: UIColor = MessageColor.leftViewColorGray
    var cellOutgoingTextColor: UIColor = .white
    var cellIncomingTextColor: UIColor = .black
}
