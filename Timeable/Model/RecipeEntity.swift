//
//  RecipeEntity.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 10/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

class RecipeEntity: NSManagedObject {
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(entity: RecipeEntity.entity(), insertInto: context)
        self.recipeName = name
    }
    
    convenience init(name: String) {
        self.init(entity: RecipeEntity.entity(), insertInto: CoreDataHandler.getContext())
        self.recipeName = name
        self.isPaused = true
        self.createdDate = Date()
        self.startDate = Date()
    }
}

extension RecipeEntity {
    /* Called directly from MVC update function */
    func updateRecipeTime() {
        calculateTimeToStepByTimePassed()
        if (currStepTimeRemaining <= 0.0) {
            prepareNextStep()
        }
    }
    
    /*
        Returns the step the recipe is currently running.
    */
//    func searchLeadingStep() -> StepEntity? {
//        var leadingStep: StepEntity? = nil
//        let sortedSet = sortStepsByPriority()
//        let tp = timePassedSinceStart() + pauseTimeInterval
//
//        var elapsedTime: Double = 0.0
//
//
//
//
//        for step in sortedSet {
//            elapsedTime = elapsedTime + step.totalTime
//            let time = elapsedTime - tp
//            if (time >= 0.0 && step.isComplete == false) {
//                //step incomplete, most recent step
//                leadingStep = step
//                break
//            } else {
//                //final step
//                leadingStep = step
//            }
//        }
//        return leadingStep
//    }
    
    
    /*
        When the app is inactive or suspended, we aren't running the timer loop, leading to incorrect variables. This loop updates the variables to the correct time by adding the time passed up until the current step.
        This function allows to cover all cases (as mentioned above) when the app switches between states. Despite the average running time of this function O(n) - n being number of steps - we only ever loop over the visible cells, which in this case is quite minimal but we also have the possibility of having n reach a large value
     
     The entire recipe loop would come to O(r + s)
     r - number of recipes
     s - number of steps
     because the leading step alters and we do not run over completed recipes.
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
                break
            } else {
                //step complete
                currStepTimeRemaining = 0.0
                step.timeRemaining = currStepTimeRemaining
                step.isComplete = true
            }
        }
    }
    
    func calculatePauseInterval() -> Double {
        guard let start = pauseStartDate else {
            return 0.0
        }
//        guard let end = pauseEndDate else {
//            return 0.0
//        }
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

    func prepareNextStep() -> Void {
        let sortedSet = sortStepsByPriority()
        let maxItems = sortedSet.count - 1
        let index = Int(currStepPriority)

        if (index <= maxItems) {
            let currStep = sortedSet[index]
            // TODO: Error
            currStep.isLeading = false
            currStep.isComplete = true
            currStep.timeRemaining = 0.0
            
            currStepPriority = Int16(index)
            let nextStep = sortedSet[Int(currStepPriority)]
            currStepTimeRemaining = nextStep.timeRemaining
            nextStep.isLeading = true
        }
    }
    
    /*
        Reset entire recipe
     */
    func resetEntireRecipeTo(toStep: Int = 0) {
        let sortedSet = sortStepsByPriority()
        startDate = Date()
        pauseTimeInterval = 0.0
        for (index, step) in sortedSet.enumerated() {
            if (index >= toStep) {
                step.resetStep()
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
            step.totalTime = step.totalTime + seconds
            step.timeRemaining = step.timeRemaining + seconds
        } else if (step.isComplete) {
            throw StepOptionsError.StepAlreadyComplete(message: "")
        } else {
            throw StepOptionsError.StepAlreadyComplete(message: "adjustment can only be made for an incomplete step")
        }
    }
    
    /* When a step is deleted */
    func reoganiseStepsInArr(_ sArr: [StepEntity], fromIndex: Int) {
        for i in stride(from: fromIndex, to: sArr.count, by: 1) {
            let priority = sArr[i].priority
            sArr[i].priority = priority - 1
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
        CoreDataHandler.getPrivateContext().perform {

            self.isPaused = true
            let stepSet = self.step as! Set<StepEntity>
            for s in stepSet {
                if(!self.isPaused) {
                    s.updateTotalTimeRemaining()
                    s.isPausedPrimary = true
                }
            }
            self.pauseStartDate = Date()
            CoreDataHandler.saveContext()
        }
}
    
    func unpauseStepArr() {
        let stepSet = self.step as! Set<StepEntity>
        for s in stepSet {
            if(self.isPaused) {
                s.isPausedPrimary = false
            }
        }
        pauseEndDate = Date()
        let interval = calculatePauseInterval()
        pauseTimeInterval = pauseTimeInterval + interval
    }
}
