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
        case Honeydew
        case Ocean
        case DeepOcean
    }
    
    let dataSource = ["Honeydew", "Ocean", "Deep Ocean"]
    
    var delegate: ThemeViewController?
    
    var theme: ThemeManager?
    
    var lastSelection: IndexPath?

    let themeCellId = "ThemeCellId"

    init( theme: ThemeManager?) {
        self.theme = theme
    }
    
    func applyNewTheme(indexPath: IndexPath) {
        
        guard let themeOption = Themes.init(rawValue: indexPath.row) else {
            return
        }
        
        switch themeOption {
            case .Honeydew:
                if let theme = theme {
                    theme.currentTheme = StandardLightTheme()
                    theme.currentTheme.applyTheme()
                    delegate?.refreshView()
                }

            case .Ocean:
                if let theme = theme {
                    theme.currentTheme = StandardDarkTheme()
                    theme.currentTheme.applyTheme()
                    delegate?.refreshView()
                }
            case .DeepOcean:
                ()
        }
        
    }
}
