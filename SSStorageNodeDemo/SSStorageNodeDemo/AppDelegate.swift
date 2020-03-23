//
//  AppDelegate.swift
//  SSStorageNodeDemo
//
//  Created by ixiazer on 2020/3/20.
//  Copyright © 2020 FF. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKey()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController.init(rootViewController: ViewController())
        return true
    }

}

