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
        configureRootView()
    }
    
    private func configureRootView() {
        let applicationAssembly = ApplicationAssembly()
        
        guard let conversationListViewController = applicationAssembly
            .presentationAssembly
                .conversationListViewController() else { return }
        
        let navigationController = applicationAssembly
            .presentationAssembly
            .conversationListNavigationController(rootViewController:
                                                    conversationListViewController)
        
        window = UIWindow()
        window?.rootViewController = navigationController
        
    }
    
    private func configureCoreData() {
        let coreData = CoreDataStack.shared
        
        coreData.didUpdateDataBase = { stack in
            stack.printDatabaseStatistics()
        }
        coreData.enableObservers()
    }
}
