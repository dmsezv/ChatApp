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
      
        UINavigationBar.appearance().tintColor = theme.textColor
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.textColor]
        
        if #available(iOS 13.0, *) {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            window.overrideUserInterfaceStyle = theme.userInterfaceStyle
            window.subviews.forEach { view in
                view.removeFromSuperview()
                window.addSubview(view)
            }
        } else {
            let window = UIApplication.shared.keyWindow
            window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            window?.subviews.forEach { view in
                view.removeFromSuperview()
                window?.addSubview(view)
            }
        }
        
        currentTheme = theme
    }
    
    func changeThemeTo(_ type: ThemePicker.ThemeType) {
        setupTheme(type)
    }
    
    lazy var callbackChangeTheme = { [weak self] (type: ThemePicker.ThemeType) in
        self?.setupTheme(type)
    }
}
