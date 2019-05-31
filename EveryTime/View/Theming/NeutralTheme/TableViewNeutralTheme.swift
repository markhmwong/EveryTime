//
//  TableViewNeutralTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 20/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct TableViewNeutralTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.NeutralColourPalette.offWhite
    var cellBackgroundColor: UIColor = UIColor.NeutralColourPalette.offWhite
    var cellTextColor: UIColor = UIColor.NeutralColourPalette.newspaperBlack
    var bottomBorderColor: UIColor = .clear
    var pausedTextColor: UIColor = UIColor.NeutralColourPalette.grayFaded // not used
    var highlightColor: UIColor = UIColor.NeutralColourPalette.gray // deprecated
    var selectedCellColor: UIColor = UIColor.NeutralColourPalette.gray
    var pauseButtonBackgroundActive: UIColor = UIColor.NeutralColourPalette.gray
    var pauseButtonBackgroundInactive: UIColor = UIColor.NeutralColourPalette.grayFaded
    
    static var TextColor: UIColor = UIColor.NeutralColourPalette.newspaperBlack
    static var TextColorFaded: UIColor = UIColor.NeutralColourPalette.grayFaded // deprecated
    
    var settingsCell: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    
    var mainViewStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Bold.rawValue, size: FontNeutralTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    var mainViewRecipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    var mainViewRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Bold.rawValue, size: FontNeutralTheme.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    
    var recipeHeaderStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    
    var recipeCellStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    var recipeHeaderRecipe: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    var recipeHeaderTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    var recipeHeaderStep: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Regular.rawValue, size: FontNeutralTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    
    var recipeSubtitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Bold.rawValue, size: FontNeutralTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
    
    var recipeModalOption: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Bold.rawValue, size: FontNeutralTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewNeutralTheme.TextColor, NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue]
}

