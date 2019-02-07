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
        self.expiryDate = self.createdDate!.addingTimeInterval(self.timeToSeconds(hours: hours, minutes: minutes, seconds: seconds)) //only needed for the leading step
        self.timeRemaining = self.expiryDate!.timeIntervalSince(Date())
        self.totalTime = self.timeRemaining //a stored time for reset purposes
    }
}

extension StepEntity {
    func resetStep() {
        //todo
    }
    func updateTimeRemainingWithStartDate() {
        guard let start = startDate else {
            print("StartDate is nil")
            return
        }
        print(start.timeIntervalSince(Date()))
    }
    func updateTimeRemaining() {
        guard let expiry = expiryDate else {
            return
        }
        self.timeRemaining = expiry.timeIntervalSince(Date())
    }
    
    func updateExpiry() {
        let now = Date()
        self.expiryDate = now.addingTimeInterval(self.timeRemaining)
    }
    
    func timeToSeconds(hours: Int, minutes: Int, seconds: Int) -> TimeInterval {
        return TimeInterval((hours * 3600) + (minutes * 60) + seconds)
    }
    
    func updateTotalTimeRemaining() {
        print(self.timeRemaining)
        if (self.timeRemaining <= 0.0) {
            self.timeRemaining = 0.0
            self.isComplete = true
        } else {
            updateTimeRemaining()
//            updateTimeRemainingWithStartDate()
        }
    }
    
    func timeRemainingToString() -> String {
        var timeStr = "00h00m00s"
        let (h,m,s) = self.timeRemaining.secondsToHoursMinutesSeconds()
        timeStr = "\(h.prefixZeroToInteger())h\(m.prefixZeroToInteger())m\(s.prefixZeroToInteger())s"
        return timeStr
    }
    
    func timeRemainingPausedState() -> String {
        let (h,m,s) = self.timeRemaining.secondsToHoursMinutesSeconds()
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
