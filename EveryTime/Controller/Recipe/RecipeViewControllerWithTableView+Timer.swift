//
//  RecipeViewControllerWithTableView+Timer.swift
//  EveryTime
//
//  Created by Mark Wong on 2/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension RecipeViewControllerWithTableView: TimerProtocol {
    //MARK: Timer Protocol
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func update() {
        //updates specific cell only - issue it won't continue to the next cell when the application is in the background
        
        if (!recipe.isPaused) {
            
            let sortedSet = recipe.sortStepsByPriority() //needs update
            let tp = recipe.timePassedSinceStart() + recipe.pauseTimeInterval
            var elapsedTime: Double = 0.0
            
            let visibleCellIndexPaths = self.mainView.tableView.indexPathsForVisibleRows?.sorted { (x, y) -> Bool in
                return x < y
            }
            guard let visibleCell = visibleCellIndexPaths else {
                return
            }
            
            for step in sortedSet {
                elapsedTime = elapsedTime + step.totalTime
                let time = elapsedTime - tp
                recipe.currStepName = step.stepName
                recipe.currStepPriority = step.priority
                
                if (time >= 0.0 && step.isComplete == false) {
                    //step incomplete
                    recipe.currStepTimeRemaining = time
                    step.timeRemaining = time
                    step.updateExpiry()
                    step.updateTimeRemaining()
                    
                    if (sortedSet.count - 1 > recipe.currStepPriority) {
                        let nextStep: StepEntity = sortedSet[Int(recipe.currStepPriority) + 1]
                        DispatchQueue.main.async {
                            self.mainView.headerView.updateHeaderNextStepTimeLabel(time: nextStep.timeRemainingToString())
                            self.mainView.headerView.updateHeaderNextStepTitleLabel(title: nextStep.stepName ?? "Unknown")
                            if (self.largeDisplay != nil) {
                                self.largeDisplay?.viewModel?.nextStepStr = nextStep.stepName
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.mainView.headerView.updateHeaderNextStepTimeLabel(time: "")
                            self.mainView.headerView.updateHeaderNextStepTitleLabel(title: "")
                            if (self.largeDisplay != nil) {
                                self.largeDisplay?.viewModel?.nextStepStr = ""
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.mainView.headerView.updateHeaderStepTimeLabel(time: step.timeRemainingToString())
                        self.mainView.headerView.updateHeaderStepTitleLabel(title: step.stepName ?? "Unknown")
                    }
                    
                    /// Updates full screen labels
                    if (largeDisplay != nil) {
                        largeDisplay?.viewModel?.currTimeStr = step.timeRemainingToString()
                        largeDisplay?.viewModel?.currStepStr = step.stepName ?? "Unknown"
                        largeDisplay?.viewModel?.currRecipeStr = recipe.recipeName ?? "Unknown"
                        largeDisplay?.viewModel?.stepsComplete = recipe.stepsComplete() // remove sort
                        
                    }
                    let priorityIndexPath = IndexPath(item: Int(step.priority), section: 0)
                    if (visibleCell.contains(priorityIndexPath)) {
                        let stepCell = mainView.tableView.cellForRow(at: priorityIndexPath) as! RecipeViewCell
                        DispatchQueue.main.async {
                            stepCell.updateTimeLabel(time:step.timeRemainingToString())
                            stepCell.updateCompletionStatusLabel()
                        }
                    }
                    break
                } else {
                    //step complete
                    recipe.currStepTimeRemaining = 0.0
                    step.timeRemaining = 0.0
                    step.isComplete = true
                    
                    //shows last step when complete
                    if (sortedSet.count - 1 == recipe.currStepPriority) {
                        DispatchQueue.main.async {
                            self.mainView.headerView.updateHeaderStepTimeLabel(time: "00h 00m 00s")
                            self.mainView.headerView.updateHeaderStepTitleLabel(title: self.recipe.currStepName ?? "Unknown")
                        }
                    }
                    
                    /// Update steps complete count
                    if (largeDisplay != nil) {
                        largeDisplay?.viewModel?.totalSteps = recipe.stepSetSize()
                        largeDisplay?.viewModel?.stepsCompleteString = { largeDisplay?.viewModel?.stepsCompleteString }()
                    }
                    
                    let priorityIndexPath = IndexPath(item: Int(step.priority), section: 0)
                    if (visibleCell.contains(priorityIndexPath)) {
                        let stepCell = mainView.tableView.cellForRow(at: priorityIndexPath) as! RecipeViewCell
                        DispatchQueue.main.async {
                            stepCell.updateTimeLabel(time:step.timeRemainingToString())
                            stepCell.updateCompletionStatusLabel()
                        }
                    }
                    
                    // a check to see if the entire recipe is complete
                    if (sortedSet.count - 1 == Int(recipe.currStepPriority)) {
                        stopTimer()
                    }
                }
            }
            
            if (recipe.currStepTimeRemaining <= 0.1 && sortedSet.count != 0) {
                let s = sortedSet[Int(recipe.currStepPriority)]
                if (s.isComplete == false) {
                    playSound()
                }
            }
        }
    }
}
