//
//  AppDelegate.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 24.03.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginCoordinator: LoginCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()

        loginCoordinator = LoginCoordinator(navigationController: window?.rootViewController as! UINavigationController)
        loginCoordinator?.start()
        
        window?.makeKeyAndVisible()
        return true
    }
}

