//
//  LargeDisplayViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 4/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class LargeDisplayViewModel {
    
    var recipeEntity: RecipeEntity?
    
    var theme: ThemeManager?
    
    var delegate: LargeDisplayViewController?
    
    var stepsComplete: Int?
    
    var totalSteps: Int?
    
    var nextStepStr: String? {
        didSet {
            delegate?.updateViewNextStepLabel(nextStepName: nextStepStr ?? "Unknown")
        }
    }
    
    var currTimeStr: String? {
        didSet {
            /// passed on to the view controller that then handles the call to the view
            delegate?.updateViewTimeLabel(timeRemaining: currTimeStr ?? "Unknown")
        }
    }
    
    var currStepStr: String? {
        didSet {
            delegate?.updateViewStepLabel(stepName: currStepStr ?? "Unknown")
        }
    }
    
    var currRecipeStr: String? {
        didSet {
            guard let delegate = delegate else {
                return
            }
            delegate.updateViewRecipeLabel(recipeName: currRecipeStr ?? "Unknown")
        }
    }
    
    var stepsCompleteString: String? {
        didSet {
            delegate?.updateViewStepsCompleteLabel(stepComplete: "\(stepsComplete ?? 1)/\(totalSteps ?? 0)" )
        }
    }
    
    init(time: String, stepName: String, recipeName: String, recipeEntity: RecipeEntity? = nil, sortedSet: [StepEntity]?, theme: ThemeManager?) {
        self.theme = theme
        self.totalSteps = recipeEntity?.stepSetSize()
        self.recipeEntity = recipeEntity
        
        if let r = recipeEntity {
            self.stepsComplete = r.stepsComplete()
        }
        
        if let pause = recipeEntity?.isPaused {
            delegate?.updateViewControls(pauseState: pause)
        }
        
        defer {
            self.currTimeStr = time
            self.currStepStr = stepName
            self.currRecipeStr = recipeName
            
            if let r = recipeEntity, let sortedSet = sortedSet {
                let priority = r.currStepPriority
                if (priority < sortedSet.count - 1) {
                    self.nextStepStr = sortedSet[Int(r.currStepPriority) + 1].stepName
                } else if (priority == sortedSet.count - 1) {
                    self.nextStepStr = ""
                } else {
                    self.nextStepStr = sortedSet[Int(r.currStepPriority)].stepName
                }
            }
        }
    }
    
    func updateFullScreen(sortedSet: [StepEntity]?) {
        guard let delegate = delegate else {
            return
        }
        delegate.updateViewStepsCompleteLabel(stepComplete: "\(stepsComplete ?? 1)/\(totalSteps ?? 0)")
        delegate.updateViewRecipeLabel(recipeName: currRecipeStr ?? "Unknown")
        delegate.updateViewNextStepLabel(nextStepName: nextStepStr ?? "Unknown")
        delegate.updateViewTimeLabel(timeRemaining: currTimeStr ?? "Unknown")
        delegate.updateViewStepLabel(stepName: currStepStr ?? "Unknown")
        
        if let r = recipeEntity, let sortedSet = sortedSet {
            let priority = r.currStepPriority
            if (priority < sortedSet.count - 1) {
                self.nextStepStr = sortedSet[Int(r.currStepPriority) + 1].stepName
            } else if (priority == sortedSet.count - 1) {
                self.nextStepStr = ""
            } else {
                self.nextStepStr = sortedSet[Int(r.currStepPriority)].stepName
            }
        }
    }
    
    deinit {
//        print("deinit largedisplayviewmodel")
    }
}
