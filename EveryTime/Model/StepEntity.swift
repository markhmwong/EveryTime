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
        self.isPausedPrimary = false
        self.createdDate = Date()
        self.expiryDate = self.createdDate!.addingTimeInterval(self.timeToSeconds(hours: hours, minutes: minutes, seconds: seconds)) //only needed for the leading step
        self.timeRemaining = self.expiryDate!.timeIntervalSince(Date()).rounded()
        self.totalTime = self.timeRemaining //total time - a reference to the time fo the step for reset purposes
        //        self.isSequential = true //todo
        self.timeAdjustment = 0.0
    }
}

extension StepEntity {
    func resetStep() {
        totalTime = totalTime - timeAdjustment
        timeAdjustment = 0.0
        timeRemaining = totalTime
        updateExpiry()
        isComplete = false
        
        if (priority == 0) {
            isLeading = true
        } else {
            isLeading = false
        }
    }
    
    func updateTimeRemaining() {
        guard let expiry = expiryDate else {
            return
        }
        timeRemaining = expiry.timeIntervalSince(Date())
    }
    
    func updateExpiry() {
        let now = Date()
        expiryDate = now.addingTimeInterval(timeRemaining)
    }
    
    func timeToSeconds(hours: Int, minutes: Int, seconds: Int) -> TimeInterval {
        return TimeInterval((hours * 3600) + (minutes * 60) + seconds)
    }
    
    func updateStep() {
        totalTime = totalTime - timeAdjustment
        timeAdjustment = 0.0
        timeRemaining = 0.0
        isComplete = true
        isLeading = false
    }
    
    func getRawValues() -> (Int, Int, Int) {
        return timeRemaining.secondsToHoursMinutesSeconds()
    }
    
    func timeRemainingToString() -> String {
        let (h,m,s) = self.timeRemaining.secondsToHoursMinutesSeconds()
        return "\(h.prefixZeroToInteger())h \(m.prefixZeroToInteger())m \(s.prefixZeroToInteger())s"
    }
    
    func timeRemainingPausedState() -> String {
        let (h,m,s) = timeRemaining.secondsToHoursMinutesSeconds()
        return self.hrsMinsSecsToString(h: h, m: m, s: s)
    }
    
    func hrsMinsSecsToString(h: Int, m: Int, s: Int) -> String {
        return "\(h)h\(m)m\(s)s"
    }
    
    func updatePauseState() {
        if (isPausedPrimary) {
            isPausedPrimary = !isPausedPrimary
        } else {
            isPausedPrimary = !isPausedPrimary
        }
    }
}
