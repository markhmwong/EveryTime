//
//  TableViewLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TableViewStandardLightTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.HoneydewColourPalette.lightGray
    var cellBackgroundColor: UIColor = UIColor.OceanColourPalette.white
    var cellTextColor: UIColor = UIColor.HoneydewColourPalette.darkTeal
    
    var cellAttributedText: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
}
