//
//  StandardLightThemView.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NavigationStandardOrangeTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor.OrangeColourPalette.orange
    static var textColour: UIColor = UIColor.OrangeColourPalette.darkOrange
    static var titleColour: UIColor = UIColor.OrangeColourPalette.darkOrange
//    var bottomBorderColor: UIColor = UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.5)

    
    var item: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardOrangeTheme.textColour,
        NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue
    ]
    var title: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Bold.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b2).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardOrangeTheme.textColour,
        NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue
    ]

}
