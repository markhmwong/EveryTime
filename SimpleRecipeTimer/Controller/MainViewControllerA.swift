//
//  MainViewControllerA.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 14/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

class MainViewControllerA: BaseCollectionViewController<RecipeCell, RecipeEntity> {
    
    var cellId: String? {
        set {
            self._cellId = "recipeCellId"
        }
        get {
            return self._cellId
        }
    }
}
