//
//  TableViewLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TableViewStandardLightTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.LightMintColourPalette.lightGray
    var cellBackgroundColor: UIColor = UIColor.LightMintColourPalette.white
    var cellTextColor: UIColor = UIColor.LightMintColourPalette.darkTeal
    var bottomBorderColor: UIColor = UIColor.LightMintColourPalette.lightGray
    var pausedTextColor: UIColor = UIColor.LightMintColourPalette.gray
    var highlightColor: UIColor = UIColor.LightMintColourPalette.teal
    var selectedCellColor: UIColor = UIColor.LightMintColourPalette.lightTeal
    var pauseButtonBackgroundActive: UIColor = UIColor.LightMintColourPalette.teal
    var pauseButtonBackgroundInactive: UIColor = UIColor.LightMintColourPalette.lightTeal

    static var TextColor: UIColor = UIColor.LightMintColourPalette.darkTeal
    static var TextColorFaded: UIColor = UIColor.LightMintColourPalette.darkTealFaded

    var settingsCell: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    var mainViewStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    var mainViewRecipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    var mainViewRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    var recipeHeaderStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    var recipeCellStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    var recipeHeaderRecipe: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    var recipeHeaderTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    var recipeHeaderStep: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    var recipeSubtitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]

    var recipeModalOption: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
}
