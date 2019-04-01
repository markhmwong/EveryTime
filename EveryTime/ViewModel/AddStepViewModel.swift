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

enum ErrorsToThrow: Error {
    case labelNotFilled
    case labelLengthTooLong
    case labelInvalidLength
    case labelLengthTooShort
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
    
    func validateInputValues() throws {
        guard stepValues.name != "" else {
            throw ErrorsToThrow.labelNotFilled
        }
        
        guard let length = stepValues.name?.count else {
            throw ErrorsToThrow.labelInvalidLength
        }
        
        guard length >= minCharacterLimitForNameLabel else {
            throw ErrorsToThrow.labelLengthTooShort
        }

        //catch character limit
        guard length <= maxCharacterLimitForNameLabel else {
            throw ErrorsToThrow.labelLengthTooLong
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
