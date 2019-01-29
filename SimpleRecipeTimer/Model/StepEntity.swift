//
//  StepEntity.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 10/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

class StepEntity: NSManagedObject {
    convenience init(name: String, entity:NSEntityDescription, context: NSManagedObjectContext) {
        self.init(entity: entity, insertInto: context)
    }
    
    convenience init(name: String, hours: Int, minutes: Int, seconds: Int, priority: Int16) {
        self.init(entity: StepEntity.entity(), insertInto: CoreDataHandler.getContext())
        self.stepName = name
        self.priority = priority
        self.isComplete = false
        self.isLeading = false
        self.isSequential = true
        self.isPausedPrimary = false
        self.createdDate = Date()
        self.expiryDate = self.createdDate!.addingTimeInterval(self.timeToSeconds(hours: hours, minutes: minutes, seconds: seconds))
        self.totalElapsedTime = self.expiryDate!.timeIntervalSince(Date())
        self.storedTotalElapsedTime = self.totalElapsedTime //a stored time for reset purposes
    }
}

extension StepEntity {
    func resetStep() {
        //todo
    }
    func updateExpiry() {
        self.expiryDate = Date().addingTimeInterval(self.totalElapsedTime)
    }
    
    func timeToSeconds(hours: Int, minutes: Int, seconds: Int) -> TimeInterval {
        return TimeInterval((hours * 3600) + (minutes * 60) + seconds)
    }
    
    func updateTotalElapsedTime() {
        self.totalElapsedTime = expiryDate!.timeIntervalSince(Date())
        if (self.totalElapsedTime <= 0) {
            self.totalElapsedTime = 0
        }        
    }
    
    func isStepComplete() -> Bool {
        if (self.totalElapsedTime.isLessThanOrEqualTo(0.0)) {
            self.isComplete = true
            self.isLeading = false
            return true
        } else {
            return false
        }
    }
    
    func timeRemaining() -> String {
        var timeStr = "00h00m00s"
        let (h,m,s) = self.totalElapsedTime.secondsToHoursMinutesSeconds()
        timeStr = "\(h.prefixZeroToInteger())h\(m.prefixZeroToInteger())m\(s.prefixZeroToInteger())s"
        return timeStr
    }
    
    func timeRemainingPausedState() -> String {
        let (h,m,s) = self.totalElapsedTime.secondsToHoursMinutesSeconds()
        return self.hrsMinsSecsToString(h: h, m: m, s: s)
    }
    
    func hrsMinsSecsToString(h: Int, m: Int, s: Int) -> String {
        return "\(h)h\(m)m\(s)s"
    }
    
    func updatePauseState() {
        if (self.isPausedPrimary) {
            self.isPausedPrimary = !self.isPausedPrimary
        } else {
            self.isPausedPrimary = !self.isPausedPrimary
        }
    }
}
