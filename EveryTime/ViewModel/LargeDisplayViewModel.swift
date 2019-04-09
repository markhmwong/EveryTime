//
//  LargeDisplayViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 4/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class LargeDisplayViewModel {
    
    var delegate: LargeDisplayViewController?
    
    var currTimeStr: String {
        didSet {
            /// passed on to the view controller that then handles the call to the view
            delegate?.updateViewTimeLabel(timeRemaining: currTimeStr)
        }
    }
    
    var currStepStr: String {
        didSet {
            delegate?.updateViewStepLabel(stepName: currStepStr)
        }
    }
    
    var currRecipeStr: String {
        didSet {
//            delegate?.updateViewRecipeLabel(recipeName: currRecipeStr)
            delegate?.updateViewRecipeLabel(recipeName: currRecipeStr)
        }
    }
    
    init(delegate: LargeDisplayViewController?, time: String, step: String, recipe: String) {
        self.delegate = delegate
        self.currTimeStr = time
        self.currStepStr = step
        self.currRecipeStr = recipe
    }
}
