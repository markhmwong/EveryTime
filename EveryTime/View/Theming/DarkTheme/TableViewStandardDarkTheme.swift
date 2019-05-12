//
//  TableViewStandardDarkThem.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct TableViewStandardDarkTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.DarkMintColourPalette.black
    var cellBackgroundColor: UIColor = UIColor.DarkMintColourPalette.lightBlack
    var cellTextColor: UIColor = UIColor.DarkMintColourPalette.white
    var bottomBorderColor: UIColor = .clear
    var pausedTextColor: UIColor = UIColor.DarkMintColourPalette.darkGray
    var highlightColor: UIColor = UIColor.DarkMintColourPalette.green
    var selectedCellColor: UIColor = UIColor.DarkMintColourPalette.green
    
    static var TextColor: UIColor = UIColor.DarkMintColourPalette.white
    static var TextColorFaded: UIColor = UIColor.DarkMintColourPalette.whiteFaded
    
    var settingsCell: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    
    var mainViewStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    var mainViewRecipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    var mainViewRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    
    var recipeCellStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    var recipeCellHeaderRecipe: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    var recipeCellHeaderTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    var recipeCellHeaderStep: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Regular.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
    
    var recipeSubtitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDarkTheme.FontStyle.Bold.rawValue, size: FontStandardDarkTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDarkTheme.TextColor, NSAttributedString.Key.kern: FontStandardDarkTheme.FontKern.General.floatValue]
}
