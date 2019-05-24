//
//  TableViewLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TableViewStandardGrapeTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.GrapeColourPalette.pastelGreen
    var cellBackgroundColor: UIColor = UIColor.GrapeColourPalette.pastelGreen
    var cellTextColor: UIColor = UIColor.GrapeColourPalette.darkPurple
    var bottomBorderColor: UIColor = .clear
    var pausedTextColor: UIColor = UIColor.GrapeColourPalette.blackFaded
    var highlightColor: UIColor = UIColor.GrapeColourPalette.purple //not in use
    var selectedCellColor: UIColor = UIColor.GrapeColourPalette.darkPurple
    var pauseButtonBackgroundActive: UIColor = UIColor.GrapeColourPalette.darkPurple
    var pauseButtonBackgroundInactive: UIColor = UIColor.GrapeColourPalette.purple

    static var TextColor: UIColor = UIColor.GrapeColourPalette.darkPurple
    static var TextColorFaded: UIColor = UIColor.GrapeColourPalette.blackFaded

    var settingsCell: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    
    var mainViewStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Bold.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    var mainViewRecipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    
    var mainViewRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Bold.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    
    var recipeHeaderStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    
    var recipeCellStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    var recipeHeaderRecipe: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    var recipeHeaderTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    var recipeHeaderStep: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Regular.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
    
    var recipeSubtitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Bold.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]

    var recipeModalOption: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Bold.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardGrapeTheme.TextColor, NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue]
}
