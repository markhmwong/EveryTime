//
//  NavigationStandardDarkTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

import UIKit

struct NavigationStandardDarkTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor.OceanColourPalette.lightBlack
    static var textColour: UIColor = UIColor.OceanColourPalette.white
    static var titleColour: UIColor = UIColor.OceanColourPalette.teal
//    var bottomBorderColor: UIColor { return UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.5) }
    
    
    var navigationItem: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardDarkTheme.textColour,
        NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue
    ]
    var navigationTitle: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b2).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardDarkTheme.titleColour,
        NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue
    ]
}
