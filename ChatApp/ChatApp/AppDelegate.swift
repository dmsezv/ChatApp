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
        logLyfeCycleWith(#function)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        logLyfeCycleWith(#function)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logLyfeCycleWith(#function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logLyfeCycleWith(#function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logLyfeCycleWith(#function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logLyfeCycleWith(#function)
    }
}

