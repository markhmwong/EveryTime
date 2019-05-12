//
//  Theme.swift
//  EveryTime
//
//  Created by Mark Wong on 5/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum Themes: Int {
    case LightMint
    case DarkMint
    case DeepMint
}

class ThemeManager {
    //must keep this order!

    
    static var userDefaultsKey: String = "theme"
    var currentTheme: ThemeProtocol
    
    init(currentTheme: ThemeProtocol = StandardLightTheme()) {
        self.currentTheme = currentTheme
    }
    
    class func getSavedTheme(option: Int) -> ThemeProtocol? {
        
        guard let themeOption = Themes.init(rawValue: option) else {
            return nil
        }
        
        switch themeOption {
        case .LightMint:
                return StandardLightTheme()
        case .DarkMint:
                return StandardDarkTheme()
        case .DeepMint:
            ()
        }
        return nil
    }
    
    class func getCurrentTheme() -> Themes {
        let themeOption = UserDefaults.standard.integer(forKey: userDefaultsKey)
        
        if let themeOption = Themes.init(rawValue: themeOption) {
            switch themeOption {
            case .LightMint:
                return .LightMint
            case .DarkMint:
                return .DarkMint
            case .DeepMint:
                ()
            }
        }
        
        return .LightMint
    }
}



//struct StandardLightTheme: ThemeProtocol {
//    var view: View = View()
//    func applyTheme() {
//
//        NavView.appearance().backgroundColor = UIColor.blue
//    }
//}

//struct StandardDarkTheme: ThemeProtocol {
//    var view: View
//
//    func applyTheme() {
//        NavView.appearance().backgroundColor = UIColor.black
//    }
//}
//
//struct OledDarkTheme: ThemeProtocol {
//    var view: View
//
//    func applyTheme() {
//        NavView.appearance().backgroundColor = UIColor.black
//    }
//}
