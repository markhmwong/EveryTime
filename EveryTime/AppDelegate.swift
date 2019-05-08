//
//  AppDelegate.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    var myOrientation: UIInterfaceOrientationMask = .portrait
    
    var window: UIWindow?
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
//        UIFont.overrideInitialize() // to be determined
        let theme: ThemeManager = ThemeManager.init(currentTheme: StandardLightTheme())
        let main = MainViewController(viewModel: nil)
        main.viewModel = MainViewModel(delegate: main, theme: theme)
        
        window?.rootViewController = UINavigationController(rootViewController: main)
        
        return true
    }
    /* not running, active, inactive, suspended and background*/

    func applicationWillResignActive(_ application: UIApplication) {
        CoreDataHandler.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataHandler.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataHandler.saveContext()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }

}

