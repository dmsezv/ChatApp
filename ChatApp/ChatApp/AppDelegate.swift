//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.02.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureApp()
        
        return true
    }
    
    private func configureApp() {
        FirebaseApp.configure()
        ThemePicker.shared.changeThemeTo(.classic)
        
        configureCoreData()
    }
    
    private func configureCoreData() {
        let coreData = CoreDataStack.shared
        
        coreData.didUpdateDataBase = { stack in
            stack.printDatabaseStatistics()
        }
        coreData.enableObservers()
    }
}
