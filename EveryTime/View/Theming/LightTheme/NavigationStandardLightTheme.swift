//
//  StandardLightThemView.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NavigationStandardLightTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
    static var textColour: UIColor = UIColor.HoneydewColourPalette.darkTeal
    static var titleColour: UIColor = UIColor.HoneydewColourPalette.darkTeal
//    var bottomBorderColor: UIColor = UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.5)

    
    var navigationItem: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour,
        NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue
    ]
    var navigationTitle: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour,
        NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue
    ]

}
