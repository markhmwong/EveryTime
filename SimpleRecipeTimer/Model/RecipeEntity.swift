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
        self.isPaused = false
        self.createdDate = Date()
        self.startDate = Date()
    }
}


/*
 Rewrite v4
*/
extension RecipeEntity {
    /* Called directly from MVC update function */
    func updateRecipeTime() {
        
        //working
        calculateTimeToStepByTimePassed()
        if (currStepTimeRemaining <= 0.0) {
            prepareNextStep()
        }
    }
    
    func searchLeadingStep() -> StepEntity? {
        var leadingStep: StepEntity? = nil
        let sortedSet = sortStepsByPriority()
        let tp = timePassedSinceStart() + pauseTimeInterval
        var elapsedTime: Double = 0.0
        for step in sortedSet {
            elapsedTime = elapsedTime + step.totalTime
            let time = elapsedTime - tp
            if (time >= 0.0 && step.isComplete == false) {
                //step incomplete, most recent step
                leadingStep = step
                break
            } else {
                //final step
                leadingStep = step
            }
        }
        return leadingStep
    }
    
    //the function below uses a condition to check what step we have completed. However, right now the clock stops at the end of its' expiry date
    //before it begins the next step. This method allows us to not check for the isCompleted boolean but calculate the step number by time passed
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
        guard let end = pauseEndDate else {
            return 0.0
        }
        
        return start.timeIntervalSince(end)
    }
    
    func updateStepInRecipe(_ step: StepEntity) -> Void {
        currStepName = step.stepName
        currStepPriority = step.priority
        currStepTimeRemaining = step.timeRemaining
        let expiryDate = Date().addingTimeInterval(step.timeRemaining)
        currStepExpiryDate = expiryDate // this is pretty important and must be updated whenever a change is made to the organised steps
    }
    
    func timeRemainingForCurrentStepToString() -> String {
        let (h,m,s) = currStepTimeRemaining.secondsToHoursMinutesSeconds()
        return "\(h.prefixZeroToInteger())h\(m.prefixZeroToInteger())m\(s.prefixZeroToInteger())s"
    }
    
    func sumStepsForExpectedElapsedTime() {
        let unsortedSet = step as! Set<StepEntity>
        var total = 0.0
        for step in unsortedSet {
            total = total + step.timeRemaining
        }
        totalTimeRemaining = total
    }
    
    //to be determined
    func loadEntity() {
//        let sortedStepArr = sortStepsByPriority()
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
        let currStep = sortedSet[index]
        
        currStep.isLeading = false
        currStep.isComplete = true
        currStep.timeRemaining = 0.0
        if (index < maxItems) {
            currStepPriority = Int16(index + 1)
            let nextStep = sortedSet[Int(currStepPriority)]
            currStepTimeRemaining = nextStep.timeRemaining
            nextStep.isLeading = true
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
//        updateExpiryDateForCurrentStep()
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
//            if let singleEntity = CoreDataHandler.fetchByDate(in: RecipeEntity.self, date: r.createdDate!) {
//                singleEntity.isPaused = pauseState
//            }
            self.isPaused = true
            let stepSet = self.step as! Set<StepEntity>
            for s in stepSet {
                if(!self.isPaused) {
                    s.updateTotalTimeRemaining()
                    s.isPausedPrimary = true
                }
            }
            //                        CoreDataHandler.saveContext()
            self.pauseStartDate = Date()

        }
        

//        updateTimeRemainingForCurrentStep()
            }
    
    func unpauseStepArr() {
        let stepSet = self.step as! Set<StepEntity>
        for s in stepSet {
            if(self.isPaused) {
//                s.updateExpiry()
                s.isPausedPrimary = false
            }
        }
        pauseEndDate = Date()
        let interval = calculatePauseInterval()
        pauseTimeInterval = pauseTimeInterval + interval
    }
}
