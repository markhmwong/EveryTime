//
//  NavigationStandardDeepMintTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 12/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NavigationStandardDeepMintTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor.DeepMintColourPalette.lightBlack
    static var textColour: UIColor = UIColor.DeepMintColourPalette.white
    static var titleColour: UIColor = UIColor.DeepMintColourPalette.green
    
    
    var item: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardDeepMintTheme.textColour,
        NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue
    ]
    var title: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b2).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardDeepMintTheme.titleColour,
        NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue
    ]
}
