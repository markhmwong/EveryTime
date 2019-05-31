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
    
    var theme: ThemeManager?
    
    var fullScreenButtonSize: CGSize {
        get {
            let size = 18.0
            guard let theme = theme else {
                
                if (UIDevice.current.iPad) {
                    return CGSize(width: size * 1.5, height: size * 1.5)
                }
                
                return CGSize(width: size, height: size)
            }
            
            let multiplier = theme.currentTheme.button.buttonSizeMultiplier
            
            return CGSize(width: size * multiplier, height: size * multiplier)
        }
    }
    
    func dataSourceForStep() -> StepEntity {
        return dataSource[stepSelected]
    }
    
    init(theme: ThemeManager) {
        self.theme = theme
    }
    
    func setStep() {
        step = dataSourceForStep()
    }
}
