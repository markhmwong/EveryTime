//
//  NavigationNeutralTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 20/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NavigationNeutralTheme: NavigationThemeProtocol {
    var backgroundColor: UIColor = UIColor.NeutralColourPalette.gray
    static var textColour: UIColor = UIColor.NeutralColourPalette.newspaperBlack
    static var titleColour: UIColor = UIColor.NeutralColourPalette.newspaperBlack
    
    
    var item: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationNeutralTheme.textColour,
        NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue
    ]
    var title: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b2).value)!,
        NSAttributedString.Key.foregroundColor: NavigationNeutralTheme.titleColour,
        NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue
    ]
}
