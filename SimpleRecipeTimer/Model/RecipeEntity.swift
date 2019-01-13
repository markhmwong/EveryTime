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
        
        //to be changed
        let sEntity = StepEntity(name: "SampleStep", hours: 1, minutes: 30, seconds: 0)
        self.addToStep(sEntity)
        
        self.updateElapsedTimeToShortestElapsedTime()
        self.updateExpiryTime()
    }
}

extension RecipeEntity {
    func timeRemaining() -> String {
        var timeStr = "00h00m00s"
        if (!self.totalElapsedTime.isLess(than: 0.0)) {
            let (h,m,s) = self.totalElapsedTime.secondsToHoursMinutesSeconds()
            timeStr = "\(h.prefixZeroToInteger())h\(m.prefixZeroToInteger())m\(s.prefixZeroToInteger())s"
        }
        return timeStr
    }
    
    func updateRecipeElapsedTime() {
        guard let expiry = self.expiryDate else {
            return
        }
        self.totalElapsedTime = expiry.timeIntervalSince(Date())
    }
    
    func updateExpiryTime() {
        self.expiryDate = Date().addingTimeInterval(self.totalElapsedTime)
    }
    
    func unpauseStepArr() {
        let stepSet = self.step as! Set<StepEntity>
        for s in stepSet {
            if(self.isPaused) {
                s.updateExpiry()
                s.isPausedPrimary = false
            }
        }
        self.updateExpiryTime()
    }
    
    func pauseStepArr() {
        let stepSet = self.step as! Set<StepEntity>
        for s in stepSet {
            if(!self.isPaused) {
                s.updateTotalElapsedTime()
                s.isPausedPrimary = true
            }
        }
        self.updateElapsedTimeToShortestElapsedTime()
    }
    
    func updateElapsedTimeToShortestElapsedTime() {
        guard let stepSet = self.step as? Set<StepEntity> else {
            return
        }
        
        guard let firstItem = stepSet.first else {
            return
        }
        var currShortestTime: TimeInterval = firstItem.totalElapsedTime
        for step in stepSet {
            
            if (currShortestTime > step.totalElapsedTime) {
                currShortestTime = step.totalElapsedTime
            }
        }
        self.totalElapsedTime = currShortestTime
    }
    
    func sortSteps() -> [StepEntity] {
        let unsortedSet = self.step as! Set<StepEntity>
        let sortedSet = unsortedSet.sorted { (x, y) -> Bool in
            return (x.createdDate?.compare(y.createdDate!) == .orderedAscending)
        }
        return sortedSet
    }
    
}
