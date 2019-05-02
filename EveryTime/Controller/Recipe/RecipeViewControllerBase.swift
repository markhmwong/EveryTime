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
    
    //Collection Datasource - move to viewmodel
    let stepCellId = "stepCellId"
//    var stepSet: Set<StepEntity>!
//    var stepArr: [StepEntity] = []
    var recipe: RecipeEntity!

    var mainViewControllerDelegate: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
