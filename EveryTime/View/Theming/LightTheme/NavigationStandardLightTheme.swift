//
//  StandardLightThemView.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NavigationStandardLightTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor.LightMintColourPalette.teal
    static var textColour: UIColor = UIColor.LightMintColourPalette.darkTeal
    static var titleColour: UIColor = UIColor.LightMintColourPalette.darkTeal
//    var bottomBorderColor: UIColor = UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.5)

    
    var item: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour,
        NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue
    ]
    var title: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b2).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour,
        NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue
    ]

}
