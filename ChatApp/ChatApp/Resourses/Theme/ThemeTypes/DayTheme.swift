//
//  DayTheme.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit

struct DayTheme: ThemeProtocol {
    var typeTheme: ThemePicker.ThemeType = .day
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var userInterfaceStyle: UIUserInterfaceStyle = .light
}
