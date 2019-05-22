//
//  TableViewLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TableViewStandardOrangeTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.OrangeColourPalette.white
    var cellBackgroundColor: UIColor = UIColor.OrangeColourPalette.white
    var cellTextColor: UIColor = UIColor.OrangeColourPalette.white
    var bottomBorderColor: UIColor = UIColor.OrangeColourPalette.white
    var pausedTextColor: UIColor = UIColor.OrangeColourPalette.orangeFaded
    var highlightColor: UIColor = UIColor.OrangeColourPalette.white //not in use
    var selectedCellColor: UIColor = UIColor.OrangeColourPalette.orangeFaded
    var pauseButtonBackgroundActive: UIColor = UIColor.OrangeColourPalette.orangeFaded
    var pauseButtonBackgroundInactive: UIColor = UIColor.OrangeColourPalette.yellow

    static var TextColor: UIColor = UIColor.OrangeColourPalette.darkOrange
    static var TextColorFaded: UIColor = UIColor.OrangeColourPalette.orangeFaded

    var settingsCell: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Bold.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    
    var mainViewStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Bold.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    var mainViewRecipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    
    var mainViewRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Bold.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    
    var recipeHeaderStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    
    var recipeCellStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    var recipeHeaderRecipe: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    var recipeHeaderTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    var recipeHeaderStep: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Regular.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
    
    var recipeSubtitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Bold.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]

    var recipeModalOption: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Bold.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardOrangeTheme.TextColor, NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue]
}
