//
//  RecipeViewControllerBase.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeViewControllerBase: UIViewController {
    var timer: Timer?
    
    //Collection Datasource
    let stepCellId = "stepCellId"
    var stepSet: Set<StepEntity>!
    var stepArr: [StepEntity] = []
    
    var mainViewControllerDelegate: MainViewController?
    
    var recipe: RecipeEntity!
    
    func prepareViewController() {
        
    }
    
    func prepareView() {
        
    }
    
    func prepareAutoLayout() {
        
    }
}
