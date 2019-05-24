//
//  StandardLightThemView.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NavigationStandardGrapeTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor.GrapeColourPalette.purple
    static var textColour: UIColor = UIColor.GrapeColourPalette.darkPurple
    static var titleColour: UIColor = UIColor.GrapeColourPalette.darkPurple
//    var bottomBorderColor: UIColor = UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.5)

    
    var item: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardGrapeTheme.textColour,
        NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue
    ]
    var title: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Bold.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b2).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardGrapeTheme.textColour,
        NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue
    ]

}
