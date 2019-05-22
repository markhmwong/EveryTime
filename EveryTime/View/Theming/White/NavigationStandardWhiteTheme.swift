//
//  StandardLightThemView.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NavigationStandardWhiteTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor.WhiteColourPalette.white
    static var textColour: UIColor = UIColor.WhiteColourPalette.black
    static var titleColour: UIColor = UIColor.WhiteColourPalette.black
//    var bottomBorderColor: UIColor = UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.5)

    
    var item: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardWhiteTheme.textColour,
        NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue
    ]
    var title: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Bold.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b2).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardWhiteTheme.textColour,
        NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue
    ]

}
