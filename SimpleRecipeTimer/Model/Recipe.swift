//
//  Recipe.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 30/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//
//  Description
//

import Foundation
import CoreData

class Recipe: NSObject {
    var coreDataContext: NSManagedObjectContext? = nil
    var name: String = "Recipe"
    var totalElapsedTime: TimeInterval = 0.0
    var stepArr: [Step] = []
    var indexPathNumber: Int = 0
    var isPaused: Bool = false
    var expiryDate: Date = Date()
    
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    init(name: String, step: Step) {
        super.init()

        self.name = name
        self.stepArr.append(step)
        
        self.updateElapsedTimeToShortestElapsedTime()
        self.updateExpiryTime()
    }
    
    init(withName name: String, step: Step, coreDataContext: NSManagedObjectContext) {
        super.init()

        self.coreDataContext = coreDataContext
        self.name = name
        self.stepArr.append(step)
        
        self.updateElapsedTimeToShortestElapsedTime()
        self.updateExpiryTime()
    }
    
    /* test initialisers */
    init(withSampleStep step: Step, indexPathNumber: Int) {
        super.init()

        self.stepArr.append(step)
        self.indexPathNumber = indexPathNumber
    }
    
    init(withMultipleSteps steps: [Step]) {
        super.init()

        self.stepArr = steps
    }
    
    func pauseStepArr() {
        for step in self.stepArr {
            if(!self.isPaused) {
//            if (!step.isPausedSecondary) {
                step.updateTotalElapsedTime()
                step.isPausedPrimary = true
//                step.isPausedSecondary = true
            }
        }
        self.updateElapsedTimeToShortestElapsedTime()
    }
    
    func unpauseStepArr() {
        for step in self.stepArr {
            if(self.isPaused) {
                step.updateExpiry()
                step.isPausedPrimary = false
            }
        }
        self.updateExpiryTime()
    }
    
    // Will need to be called whenever a step is modified within a Recipe
    func updateElapsedTimeToShortestElapsedTime() {
        var currShortestTime: TimeInterval = self.stepArr[0].totalElapsedTime
        for step in self.stepArr {
            
            if (currShortestTime > step.totalElapsedTime) {
                currShortestTime = step.totalElapsedTime
            }
        }
        self.totalElapsedTime = currShortestTime
    }
    
    
    func updateRecipeElapsedTime() {
        self.totalElapsedTime = expiryDate.timeIntervalSince(Date())
    }
    
    func updateExpiryTime() {
        self.expiryDate = Date().addingTimeInterval(totalElapsedTime)
    }
    
    func timeRemainingDigitalFormat() -> String {
        var timeStr = "00h00m00s"
        if (!self.totalElapsedTime.isLess(than: 0.0)) {
            let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
            let components = Calendar.current.dateComponents(desiredComponents, from: Date(), to: expiryDate)
            timeStr = self.componentsFormatter.string(from: components)!
        }
        return timeStr
    }
    
    func timeRemainingWithText() -> String {
        var timeStr = "00h00m00s"
        if (!self.totalElapsedTime.isLess(than: 0.0)) {
            let (h,m,s) = self.totalElapsedTime.secondsToHoursMinutesSeconds()
            timeStr = "\(h.prefixZeroToInteger())h\(m.prefixZeroToInteger())m\(s.prefixZeroToInteger())s"
        }
        return timeStr
    }
}
