//
//  StandardDarkTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct StandardDarkTheme: ThemeProtocol {
    var navigation: NavigationThemeProtocol = NavigationStandardDarkTheme()
    var font: FontThemeProtocol = FontStandardDarkTheme()
    var attributedText: AttributedTextProtocol = AttributedTextDarkTheme()
    
    func applyTheme() {
        
    }
}
