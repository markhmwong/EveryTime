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
    
    func pauseStepArr() {
        let stepSet = self.step as! Set<StepEntity>
        for s in stepSet {
            if(!self.isPaused) {
                s.updateTotalElapsedTime()
                s.isPausedPrimary = true
            }
        }
        self.updateElapsedTimeByPriority()
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
    
    func updateElapsedTimeByPriority() {
        let entity = self.sortStepsByPriority()
        guard let firstEntity = entity.first else {
            return
        }
        self.totalElapsedTime = firstEntity.totalElapsedTime
    }
    
    func sortStepsByDate() -> [StepEntity] {
        let unsortedSet = self.step as! Set<StepEntity>
        let sortedSet = unsortedSet.sorted { (x, y) -> Bool in
            return (x.createdDate?.compare(y.createdDate!) == .orderedAscending)
        }
        return sortedSet
    }
    
    func sortStepsByPriority() -> [StepEntity] {
        let unsortedSet = self.step as! Set<StepEntity>
        print(unsortedSet.count)
        let sortedSet = unsortedSet.sorted { (x, y) -> Bool in
            return (x.priority < y.priority)
        }
        return sortedSet
    }
}
