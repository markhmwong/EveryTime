//
//  TableViewStandardDarkThem.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct TableViewStandardDarkTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.OceanColourPalette.black
    var cellBackgroundColor: UIColor = UIColor.OceanColourPalette.lightBlack
    var cellTextColor: UIColor = UIColor.OceanColourPalette.white
    
    static var TextColor: UIColor = UIColor.OceanColourPalette.white
    
    var cellAttributedText: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
}
