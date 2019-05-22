//
//  TableViewLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TableViewStandardWhiteTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.WhiteColourPalette.white
    var cellBackgroundColor: UIColor = UIColor.WhiteColourPalette.white
    var cellTextColor: UIColor = UIColor.WhiteColourPalette.black
    var bottomBorderColor: UIColor = UIColor.WhiteColourPalette.white
    var pausedTextColor: UIColor = UIColor.WhiteColourPalette.lightGray
    var highlightColor: UIColor = UIColor.WhiteColourPalette.white //not in use
    var selectedCellColor: UIColor = UIColor.WhiteColourPalette.lightGray
    var pauseButtonBackgroundActive: UIColor = UIColor.WhiteColourPalette.lightGray
    var pauseButtonBackgroundInactive: UIColor = UIColor.WhiteColourPalette.gray

    static var TextColor: UIColor = UIColor.WhiteColourPalette.black
    static var TextColorFaded: UIColor = UIColor.WhiteColourPalette.blackFaded

    var settingsCell: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    
    var mainViewStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Bold.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    var mainViewRecipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    
    var mainViewRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Bold.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    
    var recipeHeaderStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    
    var recipeCellStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    var recipeHeaderRecipe: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    var recipeHeaderTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    var recipeHeaderStep: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Regular.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
    
    var recipeSubtitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Bold.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]

    var recipeModalOption: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Bold.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardWhiteTheme.TextColor, NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue]
}
