//
//  TableViewThemeProtocol.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol TableViewThemeProtocol {
    
    var backgroundColor: UIColor { get set }
    var cellBackgroundColor: UIColor { get set }
    var cellTextColor: UIColor { get set }
    var bottomBorderColor: UIColor { get }
    var pausedTextColor: UIColor { get }
    var highlightColor: UIColor { get }
    var selectedCellColor: UIColor { get }

    static var TextColor: UIColor { get }
    static var TextColorFaded: UIColor { get }
    
    var settingsCell: [NSAttributedString.Key : Any] { get }
    
    var mainViewStepName: [NSAttributedString.Key : Any] { get }
    var mainViewRecipeName: [NSAttributedString.Key : Any] { get }
    var mainViewRecipeTime: [NSAttributedString.Key : Any] { get }
    
    var recipeHeaderRecipe: [NSAttributedString.Key : Any] { get }
    var recipeHeaderTime: [NSAttributedString.Key : Any] { get }
    var recipeHeaderStep: [NSAttributedString.Key : Any] { get }
    var recipeHeaderStepName: [NSAttributedString.Key : Any] { get }
    
    var recipeCellRecipeTime: [NSAttributedString.Key : Any] { get }
    var recipeCellStepName: [NSAttributedString.Key : Any] { get }

    var recipeSubtitle: [NSAttributedString.Key : Any] { get }
    
    var recipeModalOption: [NSAttributedString.Key : Any] { get }
}
