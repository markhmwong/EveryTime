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
    
    convenience init(name: String, hours: Int, minutes: Int, seconds: Int) {
        self.init(entity: StepEntity.entity(), insertInto: CoreDataHandler.getContext())
        self.stepName = name
        self.createdDate = Date()
        self.expiryDate = self.createdDate!.addingTimeInterval(self.timeToSeconds(hours: hours, minutes: minutes, seconds: seconds))
        self.totalElapsedTime = self.expiryDate!.timeIntervalSince(Date())
    }
}

extension StepEntity {
    func updateExpiry() {
        self.expiryDate = Date().addingTimeInterval(self.totalElapsedTime)
    }
    
    func timeToSeconds(hours: Int, minutes: Int, seconds: Int) -> TimeInterval {
        return TimeInterval((hours * 3600) + (minutes * 60) + seconds)
    }
    
    func updateTotalElapsedTime() {
        self.totalElapsedTime = expiryDate!.timeIntervalSince(Date())
    }
    
    func timeRemaining() -> String {
        var timeStr = "00h00m00s"
        if (!self.totalElapsedTime.isLess(than: 0.0)) {
            let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
            let components = Calendar.current.dateComponents(desiredComponents, from: Date(), to: expiryDate!)
            let componentsFormatter = DateComponentsFormatter()
            componentsFormatter.allowedUnits = [.hour, .minute, .second]
            timeStr = componentsFormatter.string(from: components)!
        }
        return timeStr
    }
    
    func timeRemainingPausedState() -> String {
        let (h,m,s) = self.totalElapsedTime.secondsToHoursMinutesSeconds()
        return self.hrsMinsSecsToString(h: h, m: m, s: s)
    }
    
    func hrsMinsSecsToString(h: Int, m: Int, s: Int) -> String {
        return "\(h):\(m):\(s)"
    }
    
    func updatePauseState() {
        if (self.isPausedPrimary) {
            self.isPausedPrimary = !self.isPausedPrimary
        } else {
            self.isPausedPrimary = !self.isPausedPrimary
        }
    }
}
