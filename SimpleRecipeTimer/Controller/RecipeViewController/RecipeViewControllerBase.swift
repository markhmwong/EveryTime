//
//  RecipeViewControllerBase.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 8/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
//implement protocol UIViewControllerBase
class RecipeViewControllerBase: ViewControllerBase {
    var timer: Timer?
    
    //Collection Datasource
    let stepCellId = "stepCellId"
    var stepSet: Set<StepEntity>!
    var stepArr: [StepEntity] = []
    
    var mainViewControllerDelegate: MainViewController?
    
    var recipe: RecipeEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
