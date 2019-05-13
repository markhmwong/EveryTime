//
//  ThemeViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ThemeViewModel {
    
    enum Themes: Int {
        case LightMint
        case DarkMint
        case DeepMint
    }
    
    let dataSource = ["Light Mint", "Dark Mint"] // Deep Mint
    
    var delegate: ThemeViewController?
    
    var theme: ThemeManager?
    
    var lastSelection: IndexPath?

    let themeCellId = "ThemeCellId"

    init(theme: ThemeManager?) {
        self.theme = theme
    }
    
    func applyNewTheme(indexPath: IndexPath) {
        
        guard let themeOption = Themes.init(rawValue: indexPath.row) else {
            return
        }
        
        switch themeOption {
            case .LightMint:
                if let theme = theme {
                    theme.currentTheme = StandardLightTheme()
                    theme.currentTheme.applyTheme()
                    delegate?.refreshView()
                }

            case .DarkMint:
                if let theme = theme {
                    theme.currentTheme = StandardDarkTheme()
                    theme.currentTheme.applyTheme()
                    delegate?.refreshView()
                }
            case .DeepMint:
                ()
        }
        UserDefaults.standard.set(themeOption.rawValue, forKey: "theme")
    }
}
