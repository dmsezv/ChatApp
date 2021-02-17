//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        log(#function, in: application.applicationState)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        log(#function, in: application.applicationState)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        log(#function, in: application.applicationState)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        log(#function, in: application.applicationState)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        log(#function, in: application.applicationState)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        log(#function, in: application.applicationState)
    }
}

