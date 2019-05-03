//
//  RecipeViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 2/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
enum BottomViewState: Int {
    case ShowStepOptions
    case ShowAddStep
}

class RecipeViewModel {
    
    var dataSource: [StepEntity] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let rowHeight: CGFloat = 120.0
    
    var stepSelected: Int = 0
    
    var step: StepEntity?
    
    var sortedStepSet: [StepEntity] = []
    
    var indexPathSelectedFromMainView: IndexPath?
    
    var bottomViewState: BottomViewState?
    
    func dataSourceForStep() -> StepEntity {
        return dataSource[stepSelected]
    }
    
    func setStep() {
        step = dataSourceForStep()
    }
}
