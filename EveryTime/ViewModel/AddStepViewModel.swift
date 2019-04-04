//
//  AddStepViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 30/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol AddStepViewModelProtocol {
    
}

enum AddStepLabelErrors: Error {
    case labelNotFilled
    case labelLengthTooLong
    case labelInvalidLength
    case labelLengthTooShort
}

enum AddStepPickerViewErrors: Error {
    case allZero
    case lessThanZero
    case greaterThanADay
    case greaterThanAMinute
    case greaterThanAnHour
}

struct StepValues {
    var name: String?
    var hour: Int?
    var min: Int?
    var sec: Int?
    
    mutating func updateName(str: String) {
        self.name = str
    }
    
    mutating func updateHour(hour: Int) {
        self.hour = hour
    }
    
    mutating func updateMinute(min: Int) {
        self.min = min
    }
    
    mutating func updateSecond(sec: Int) {
        self.sec = sec
    }
}

class AddStepViewModel {
    private var sEntity: StepEntity?
    private var stepValues: StepValues
    let maxCharacterLimitForNameLabel = 30
    private let minCharacterLimitForNameLabel = 1
    
    init(userSelectedValues stepValues: StepValues) {
        self.stepValues = stepValues
    }
    
    func step() -> StepValues {
        return stepValues
    }

    func validateNameInput() throws {
        guard stepValues.name != "" else {
            throw AddStepLabelErrors.labelNotFilled
        }
        
        guard let length = stepValues.name?.count else {
            throw AddStepLabelErrors.labelInvalidLength
        }
        
        guard length > minCharacterLimitForNameLabel else {
            throw AddStepLabelErrors.labelLengthTooShort
        }

        //catch character limit
        guard length <= maxCharacterLimitForNameLabel else {
            throw AddStepLabelErrors.labelLengthTooLong
        }
    }
    
    /// Must have at least one unit of time above 0
    func validatePickerView(hrs: Int, min: Int, sec: Int) throws {
        
        if (hrs == 0 && min == 0 && sec == 0) {
            throw AddStepPickerViewErrors.allZero
        }
        
        if (hrs < 0 || min < 0 || sec < 0) {
            throw AddStepPickerViewErrors.lessThanZero
        }
        
        if (hrs > 24) {
            throw AddStepPickerViewErrors.greaterThanADay
        }
        
        if (min > 60) {
            throw AddStepPickerViewErrors.greaterThanAnHour
        }
        
        if (sec > 60) {
            throw AddStepPickerViewErrors.greaterThanAMinute
        }        
    }
    
    func updateStepValues(name: String = "Step Default", hrs: Int = 0, min: Int = 0, sec: Int = 0) {
        stepValues.updateName(str: name)
        stepValues.updateHour(hour: hrs)
        stepValues.updateMinute(min: min)
        stepValues.updateSecond(sec: sec)
    }
    
    func transformToEntity(priority: Int16) {
        sEntity = StepEntity(name: stepValues.name!, hours: stepValues.hour!, minutes: stepValues.min!, seconds: stepValues.sec!, priority: priority)
    }
    
    func grabEntity() -> StepEntity? {
        return sEntity
    }
}


