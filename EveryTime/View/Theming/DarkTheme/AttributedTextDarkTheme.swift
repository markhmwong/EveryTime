//
//  AttributedTextDarkTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct AttributedTextDarkTheme: AttributedTextProtocol {
    // MARK: - Navigation
    var navigationItem: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    var navigationTitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    
    // MARK: - Text
    var bodyText: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]

    
        var cellAttributedText: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
}
