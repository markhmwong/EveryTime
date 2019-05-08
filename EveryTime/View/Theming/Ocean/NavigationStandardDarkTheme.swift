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
    var backgroundColor: UIColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
    
    var bottomBorderColor: UIColor { return UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 0.5) }
    
    
    var navigationItem: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General
    ]
    var navigationTitle: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General
    ]
}
