//
//  Theme.swift
//  EveryTime
//
//  Created by Mark Wong on 5/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ThemeManager {
    
    class var shared: ThemeManager {
        struct Static {
            static let instance: ThemeManager = ThemeManager()
        }
        return Static.instance
    }
    
    static var userDefaultsKey: String = "theme"
    static var currentAppliedThemeKey: String = "theme"
    var currentTheme: ThemeProtocol
    
    init(currentTheme: ThemeProtocol = StandardLightTheme()) {
        self.currentTheme = currentTheme
    }
    
    class func getCurrentSavedThemeProductIdentifier() -> String {
        return shared.currentTheme.productIdentifier()
    }
    
    class func saveTheme(theme: String) {
        KeychainWrapper.standard.set(theme, forKey: currentAppliedThemeKey)
    }
    
    // MARK: - The accepting parameter should be the truncated name and should not receive the the full product identifier.
    class func themeFactory(_ shortenedName: String) -> ThemeProtocol {
        
        switch shortenedName {
        case WhiteTheme.resource:
            return WhiteTheme()
        case StandardLightTheme.resource:
            return StandardLightTheme()
        case StandardDarkTheme.resource:
            return StandardDarkTheme()
        case resourceNameForProductIdentifier(IAPProducts.DeepMintThemeId):
            return DeepMintTheme()
        case OrangeTheme.resource:
            return OrangeTheme()
        case NeutralTheme.resource:
            return NeutralTheme()
        default:
            return StandardLightTheme()
        }
    }

    class func restorePurchasesToKeyChain(productIdentifier: String) {
        KeychainWrapper.standard.set(true, forKey: productIdentifier)
    }
}
