//
//  Theme.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 11.03.2021.
//

import UIKit

protocol ThemePickerDelegate: class {
    func changeThemeTo(_ type: ThemePicker.ThemeType)
}

//final class ThemePicker: ThemePickerDelegate {
//    func changeThemeTo(_ type: Theme.ThemeType) {
//        switch type {
//        case .classic:
//            Theme.current = ClassicTheme()
//        case .day:
//            Theme.current = DayTheme()
//        case .night:
//            Theme.current = NightTheme()
//        }
//    }
//
//    var changeThemeCallback = {
//
//    }
//}



final class ThemePicker: ThemePickerDelegate {
    enum ThemeType: Int {
        case classic = 100, day = 200, night = 300
    }
    
    static var shared = ThemePicker()
    private init() {}
    
    var currentTheme: ThemeProtocol = ClassicTheme()
    
   
    private func getTheme(_ type: ThemePicker.ThemeType) -> ThemeProtocol {
        switch type {
        case .classic: return ClassicTheme()
        case .day: return DayTheme()
        case .night: return NightTheme()
        }
    }
    
    private func setupTheme(_ type: ThemePicker.ThemeType) {
        let theme = ThemePicker.shared.getTheme(type)
        
        UITableView.appearance().backgroundColor = theme.backgroundColor

        
        currentTheme = theme
    }
    
    func changeThemeTo(_ type: ThemePicker.ThemeType) {
        setupTheme(type)
    }
}
