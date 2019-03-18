//
//  RecipeEntity.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 10/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreData
import AVFoundation

class RecipeEntity: NSManagedObject {
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(entity: RecipeEntity.entity(), insertInto: context)
        self.recipeName = name
    }
    
    convenience init(name: String) {
        self.init(entity: RecipeEntity.entity(), insertInto: CoreDataHandler.getContext())
        self.recipeName = name
        self.isPaused = true
        self.createdDate = Date() //like an ID, don't change through the lifecycle of the recipe
        self.startDate = self.createdDate
        self.pauseStartDate = self.createdDate
        self.wasReset = false
    }
}

extension RecipeEntity {
    /**
     # Updates the recipe.
     
     Called directly from MVC. The entry point for the main loop
     - Warning: Re-evaluate the condition in this function. The condition below runs but only when the timer is set to a interval of 0.1. The higher the timer resolution, the closer we can track the time to 0 leading to an accurate alarm. currStepTimeRemaining doesn't reach 0
    */
    func updateRecipeTime(_ mvc: MainViewController) {
        calculateTimeToStepByTimePassed()
        if (currStepTimeRemaining <= 0.1) {
            prepareNextStep(mvc)
        }
    }
    
    /**
     # Calculates time to step (needs to be redone without loop)
     
    When the app is inactive or suspended, we aren't running the timer loop, leading to incorrect timers. This loop updates the variables to the correct time by adding the time passed up until the current step.
    This function allows to cover all cases (as mentioned above) when the app switches between states.
     
     - Complexity: Despite the average running time of this function O(n) - n being number of steps - we only ever loop over the visible cells, which in this case is quite minimal but we also have the possibility of having n reach a large value
     
     The entire recipe loop would come to O(r + s)
     r - number of recipes
     s - number of steps
     because the leading step alters and we do not evaluate completed recipes guarded by the if condition
     
     - Warning: StepEntity.isLeading may not be needed any longer
    */
    func calculateTimeToStepByTimePassed() {
        let sortedSet = sortStepsByPriority()
        let tp = timePassedSinceStart() + pauseTimeInterval
        var elapsedTime: Double = 0.0
        for step in sortedSet {
            elapsedTime = elapsedTime + step.totalTime
            let time = elapsedTime - tp
            
            currStepName = step.stepName
            currStepPriority = step.priority
            
            if (time >= 0.0 && step.isComplete == false) {
                //step incomplete
                currStepTimeRemaining = time
                step.timeRemaining = currStepTimeRemaining
                step.updateExpiry()
                break
            } else {
                //step complete
                currStepTimeRemaining = 0.0
                step.timeRemaining = currStepTimeRemaining
                step.isComplete = true
            }
        }
    }
    
    func prepareNextStep(_ mvc: MainViewController) -> Void {
        let sortedSet = sortStepsByPriority()
        let maxItems = sortedSet.count - 1
        let index = Int(currStepPriority)
        
        if (index <= maxItems) {
            let currStep = sortedSet[index]
            // TODO: Error for index
            
            if (currStep.isComplete == false) {
                guard let date = createdDate else {
                    return
                }
                mvc.stepComplete(date)
            }
            currStep.isLeading = false
            currStep.isComplete = true
            currStep.timeRemaining = 0.0
            
            currStepPriority = Int16(index)
            let nextStep = sortedSet[Int(currStepPriority)]
            currStepTimeRemaining = nextStep.timeRemaining
            nextStep.isLeading = true
        }
    }
    /**
        # Plays sound when a step completes
     
        AudioServicesPlayAlertSound handles the mute/silent switch on the iPhone. Sound will not play when the mute switch is ON, instead it will vibrate. This is expected behaviour.
     
        http://iphonedevwiki.net/index.php/AudioServices

    */
//    func playSound() {
//        AudioServicesPlayAlertSound(1309)
//    }

    func calculatePauseInterval() -> Double {
        guard let start = pauseStartDate else {
            return 0.0
        }
        let pausedEnd = Date()
        return start.timeIntervalSince(pausedEnd)
    }
    
    func updateStepInRecipe(_ step: StepEntity) -> Void {
        currStepName = step.stepName
        currStepPriority = step.priority
        currStepTimeRemaining = step.timeRemaining
        let expiryDate = Date().addingTimeInterval(step.timeRemaining)
        currStepExpiryDate = expiryDate // currStepExpiryDate - this is pretty important and must be updated whenever a change is made to the organised steps
    }
    
    func timeRemainingForCurrentStepToString() -> String {
        let (h,m,s) = currStepTimeRemaining.secondsToHoursMinutesSeconds()
        return "\(h.prefixZeroToInteger())h \(m.prefixZeroToInteger())m \(s.prefixZeroToInteger())s"
    }
    
    func sumStepsForExpectedElapsedTime() {
        let unsortedSet = step as! Set<StepEntity>
        var total = 0.0
        for step in unsortedSet {
            total = total + step.timeRemaining
        }
        totalTimeRemaining = total
    }
    
    func updateTimeRemainingForCurrentStep() {
        let entityArr = sortStepsByPriority()
        
        //not first step. Get the leading step
        guard let firstStep = entityArr.first else {
            return
        }

        currStepTimeRemaining = firstStep.timeRemaining
    }
    
    /**
        Reset entire recipe
     
        Doubles as a full reset and a partial reset
     */
    func resetEntireRecipeTo(toStep: Int = 0) {
        let sortedSet = sortStepsByPriority()
        startDate = Date()
        pauseTimeInterval = 0.0
//        totalTimeRemaining = 0.0
        for (index, step) in sortedSet.enumerated() {
            if (index >= toStep) {
                step.resetStep()
//                totalTimeRemaining += step.timeRemaining// this is causing it have odd behavior with the recipe time
                if (step.priority == toStep) {
                    currStepPriority = step.priority
                    currStepTimeRemaining = step.timeRemaining
                    currStepExpiryDate = step.expiryDate
                }
            }
        }
    }
    
    /*
        Adjusts time by number of seconds. We could add or minus to modify the time
    */
    func adjustTime(by seconds: Double, selectedStep: Int) throws {
        let sortedSet = sortStepsByPriority()
        let step = sortedSet[selectedStep]
        if (selectedStep >= currStepPriority && !step.isComplete) {
            step.expiryDate?.addTimeInterval(seconds)
            step.timeRemaining = step.timeRemaining + seconds
        } else if (step.isComplete) {
            throw StepOptionsError.StepAlreadyComplete(message: "")
        } else {
            throw StepOptionsError.StepAlreadyComplete(message: "adjustment can only be made for an incomplete step")
        }
    }
    
    /**
        # Delete step in table view
     
        Reorganise step order from the step that was deleted
     */
    func reoganiseStepsInArr(fromIndex: Int) {
        let sortedSet = sortStepsByPriority()
        for i in stride(from: fromIndex, to: sortedSet.count, by: 1) {
            let priority = sortedSet[i].priority
            sortedSet[i].priority = priority - 1
        }
    }
    
    /* Recipe View Controller */
    func updateCurrStepInRecipe() -> Void {
        updateTimeRemainingForCurrentStep()
    }
  
    //for offscreen cells
    func timePassedSinceStart() -> Double {
        guard let start = startDate else {
            return 0.0
        }
        return Date().timeIntervalSince(start)
    }
}

/* Sorting */
extension RecipeEntity {
    func sortStepsByDate() -> [StepEntity] {
        let unsortedSet = step as! Set<StepEntity>
        let sortedSet = unsortedSet.sorted { (x, y) -> Bool in
            return (x.createdDate?.compare(y.createdDate!) == .orderedAscending)
        }
        return sortedSet
    }
    
    func sortStepsByPriority() -> [StepEntity] {
        let unsortedSet = step as! Set<StepEntity>
        let sortedSet = unsortedSet.sorted { (x, y) -> Bool in
            return (x.priority < y.priority)
        }
        return sortedSet
    }
}

/* Pausing */
extension RecipeEntity {
    func pauseStepArr() {
        //        CoreDataHandler.getPrivateContext().perform {
        CoreDataHandler.getContext().perform {
            let stepSet = self.step as! Set<StepEntity>
            self.isPaused = true
            
            for s in stepSet {
                if(!self.isPaused) {
                    if (s.timeRemaining <= 0.0) {
                        s.updateStep()
                    } else {
                        s.updateTimeRemaining()
                    }
                    s.isPausedPrimary = true
                }
            }
            self.pauseStartDate = Date()
        }
        CoreDataHandler.saveContext()
    }
    
    func unpauseStepArr() {
        let sortedSteps = sortStepsByPriority()
        isPaused = false
        // step expiry date not including the pause interval
        if (wasReset) {
            pauseStartDate = Date()
            startDate = Date()
            //update expiry for first step
            wasReset = false
        }
        
        for s in sortedSteps {
            if(self.isPaused) {
                s.isPausedPrimary = false
            }
            if (s.priority == 0) {
                s.updateExpiry()
            }
        }
        
        let interval = calculatePauseInterval()
        pauseTimeInterval = pauseTimeInterval + interval
        
//        currStepPriority
        CoreDataHandler.saveContext()
    }
}
