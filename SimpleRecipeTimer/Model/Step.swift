//
//  Steps.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 1/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

class Step: NSObject, StepsProtocol, StepsTimeProtocol {
    
    //MARK: State
    var isPausedPrimary: Bool = false //pauses at the step "level"
    var isRepeated: Bool = false
    var isComplete: Bool = false
    
    //always starts with the date when the object was created. But may update due to being paused
    var startDate: Date = Date()
    var expiryDate: Date = Date()
    
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    var totalElapsedTime: TimeInterval = 0.0 // time remaining
    var name: String = "PlaceholderName"
    var index: Int = 0
    
    //For UIPicker conversion
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0

    // production constructor
    init(hours: Int, minutes: Int, seconds: Int, name: String) {
        super.init()
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.name = name
        self.startDate = Date()
        self.expiryDate = startDate.addingTimeInterval(timeToSeconds())
        self.updateTotalElapsedTime()
    }
    
    //testing sample data
    init(hours: Int, minutes: Int, seconds: Int, name: String, index: Int) {
        super.init()

        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.name = name
        self.index = index
        self.startDate = Date()
        self.expiryDate = startDate.addingTimeInterval(timeToSeconds())
        self.updateTotalElapsedTime()
    }
    
    init(sample time: Date) {
        self.startDate = time
    }
    
    func updateExpiry() {
        self.expiryDate = Date().addingTimeInterval(self.totalElapsedTime)
    }
    
    // Requires to be call in the RecipeViewController because we need to ensure the latest value of
    // the elapsed time if we switch between view controllers
    // This only needs to be called in the StepViewController when the view controller is removed. Not every second
    func updateTotalElapsedTime() {
        self.totalElapsedTime = expiryDate.timeIntervalSince(Date())
    }
    
    func updatePauseState() {
        if (self.isPausedPrimary) {
            self.isPausedPrimary = !self.isPausedPrimary
        } else {
            self.isPausedPrimary = !self.isPausedPrimary
        }
    }

    //Default state is not paused
    func resetTimer() {
        self.isPausedPrimary = false
    }
    
    func initialiseTimeRemaining() -> String {
        let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
        let components = Calendar.current.dateComponents(desiredComponents, from: startDate, to: expiryDate)
        return self.componentsFormatter.string(from: components)!
    }

    func timeRemaining() -> String {
        var timeStr = "00h00m00s"
        if (!self.totalElapsedTime.isLess(than: 0.0)) {
            let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
            let components = Calendar.current.dateComponents(desiredComponents, from: Date(), to: expiryDate)
            timeStr = self.componentsFormatter.string(from: components)!
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
    
    //Total Seconds
    func timeToSeconds() -> TimeInterval {
        return TimeInterval((hours * 3600) + (minutes * 60) + seconds)
    }
}


