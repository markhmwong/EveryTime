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
        
        let themeManager: ThemeManager? = nil
        var theme: ThemeProtocol? = nil
        let main = MainViewController(viewModel: nil)
        let option = UserDefaults.standard.integer(forKey: ThemeManager.userDefaultsKey)
        
        initialiseFreeThemesToKeyChain()
        initialisePaidThemesToKeyChain()
        
        /// The transition from UserDefaultsKey to KeyChain
        if (option != 0) {
            UserDefaults.standard.set(0, forKey: ThemeManager.userDefaultsKey) //moving from userdefaults to keychain
            implementStandardThemeOnFailure(window, main)
            return true
        }
        
        /// Initial load
        guard let themeName = KeychainWrapper.standard.string(forKey: "theme") else {
            implementStandardThemeOnFailure(window, main)
            return true
        }

        /// Regular start
        theme = ThemeManager.themeFactory(themeName)
        main.viewModel = MainViewModel(delegate: main, theme: ThemeManager.init(currentTheme: theme ?? StandardLightTheme()))
        window?.rootViewController = UINavigationController(rootViewController: main)
        return true
    }
    
    func implementStandardThemeOnFailure(_ window: UIWindow?, _ main: MainViewController) {
        main.viewModel = MainViewModel(delegate: main, theme: ThemeManager.init(currentTheme: StandardLightTheme()))
        window?.rootViewController = UINavigationController(rootViewController: main)
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

    // Updates the button to show Apply / Purchase in the preview view under Themes
    func initialiseFreeThemesToKeyChain() {
        ThemeManager.restorePurchasesToKeyChain(productIdentifier: StandardLightTheme.productIdentifier)
        ThemeManager.restorePurchasesToKeyChain(productIdentifier: StandardDarkTheme.productIdentifier)
        ThemeManager.restorePurchasesToKeyChain(productIdentifier: WhiteTheme.productIdentifier)
    }
    
    /**
        KeychainWrapper.standard.set(true, forKey: OrangeTheme.productIdentifier) to temporarily enable theme

    */
    func initialisePaidThemesToKeyChain() {
    
        if KeychainWrapper.standard.bool(forKey: DeepMintTheme.productIdentifier) == nil {
            KeychainWrapper.standard.set(false, forKey: DeepMintTheme.productIdentifier)
        }

        let orangeId = OrangeTheme.productIdentifier
        if KeychainWrapper.standard.bool(forKey: orangeId) == nil {
            KeychainWrapper.standard.set(false, forKey: orangeId)
        }

        if KeychainWrapper.standard.bool(forKey: NeutralTheme.productIdentifier) == nil {
            KeychainWrapper.standard.set(false, forKey: NeutralTheme.productIdentifier)
        }
        
        if KeychainWrapper.standard.bool(forKey: OrangeTheme.productIdentifier) == nil {
            KeychainWrapper.standard.set(false, forKey: OrangeTheme.productIdentifier)
        }
        if KeychainWrapper.standard.bool(forKey: GrapeTheme.productIdentifier) == nil {
            KeychainWrapper.standard.set(false, forKey: GrapeTheme.productIdentifier)
        }

    }
}

