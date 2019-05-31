//
//  AddRecipeSettingsViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 14/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeSettingsViewModel {
    
    var options: [RecipeOptions : String]
    
    var theme: ThemeManager?
    
    init(options: [RecipeOptions : String], theme: ThemeManager?) {
        self.options = options
        self.theme = theme
    }
    
}
