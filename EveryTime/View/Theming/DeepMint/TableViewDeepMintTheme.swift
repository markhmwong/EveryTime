//
//  TableViewDeepMintTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 12/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct TableViewStandardDeepMintTheme: TableViewThemeProtocol {
    var backgroundColor: UIColor = UIColor.DeepMintColourPalette.black
    var cellBackgroundColor: UIColor = UIColor.DeepMintColourPalette.lightBlack
    var cellTextColor: UIColor = UIColor.DeepMintColourPalette.white
    var bottomBorderColor: UIColor = .clear
    var pausedTextColor: UIColor = UIColor.DeepMintColourPalette.darkGray
    var highlightColor: UIColor = UIColor.DeepMintColourPalette.green
    var selectedCellColor: UIColor = UIColor.DeepMintColourPalette.green
    var pauseButtonBackgroundActive: UIColor = UIColor.DeepMintColourPalette.green
    var pauseButtonBackgroundInactive: UIColor = UIColor.DeepMintColourPalette.greenFaded
    
    static var TextColor: UIColor = UIColor.DeepMintColourPalette.white
    static var TextColorFaded: UIColor = UIColor.DeepMintColourPalette.whiteFaded
    
    var settingsCell: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    
    var mainViewStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Bold.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    var mainViewRecipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    var mainViewRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Bold.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    
    var recipeHeaderStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    
    var recipeCellStepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    var recipeHeaderRecipe: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    var recipeHeaderTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    var recipeHeaderStep: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Regular.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    
    var recipeSubtitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Bold.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
    
    var recipeModalOption: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Bold.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardDeepMintTheme.TextColor, NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue]
}
