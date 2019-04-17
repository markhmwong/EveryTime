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
    
    init(options: [RecipeOptions : String]) {
        self.options = options
    }
    
}
