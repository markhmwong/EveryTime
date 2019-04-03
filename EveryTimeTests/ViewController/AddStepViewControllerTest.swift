//
//  AddStepViewControllerTest.swift
//  EveryTimeTests
//
//  Created by Mark Wong on 3/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import XCTest
@testable import EveryTime


class AddStepViewControllerTest: XCTestCase {
    
    /// An empty string
    func testInvalidEmptyName() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "", hour: 1, min: 5, sec: 10))
//        XCTAssertThrowsError(try viewModel.validateInputValues())
        XCTAssertThrowsError(try viewModel.validateNameInput(), "Empty Label") { (err) in
            XCTAssertEqual(err as? AddStepLabelErrors, AddStepLabelErrors.labelNotFilled)
        }
    }
    
    /// Maximum limit tests - name
    func testInvalidNameMaximumLimit() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "Some character limit over 30 Some character limit over 30 Some character limit over 30", hour: 1, min: 5, sec: 10))
        XCTAssertThrowsError(try viewModel.validateNameInput(), "Over character limit of 30") { (err) in
            XCTAssertEqual(err as? AddStepLabelErrors, AddStepLabelErrors.labelLengthTooLong)
        }
    }
    
    func testInvalidNameMaximumLimitSpaces() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "                                                                     ", hour: 1, min: 5, sec: 10))
        XCTAssertThrowsError(try viewModel.validateNameInput(), "Over character limit of 30") { (err) in
            XCTAssertEqual(err as? AddStepLabelErrors, AddStepLabelErrors.labelLengthTooLong)
        }
    }
    
    
    /// Minimum limit tests - name
    func testInvalidNameMinimumLimit() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "a", hour: 1, min: 5, sec: 10))
        XCTAssertThrowsError(try viewModel.validateNameInput(), "Minimum character limit of 1") { (err) in
            XCTAssertEqual(err as? AddStepLabelErrors, AddStepLabelErrors.labelLengthTooShort)
        }
    }
    
    func testInvalidNameMinimumLimitObscureCharacter() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "%", hour: 1, min: 5, sec: 10))
        XCTAssertThrowsError(try viewModel.validateNameInput(), "Minimum character limit of 1") { (err) in
            XCTAssertEqual(err as? AddStepLabelErrors, AddStepLabelErrors.labelLengthTooShort)
        }
    }
    
    func testInvalidNameMinimumLimitNumber() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: "1", hour: 1, min: 5, sec: 10))
        XCTAssertThrowsError(try viewModel.validateNameInput(), "Minimum character limit of 1") { (err) in
            XCTAssertEqual(err as? AddStepLabelErrors, AddStepLabelErrors.labelLengthTooShort)
        }
    }
    
    
    /// Invalid variable name (nil)
    func testInvalidNameNil() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 1, min: 5, sec: 10))
        XCTAssertThrowsError(try viewModel.validateNameInput(), "Minimum character limit of 1") { (err) in
            XCTAssertEqual(err as? AddStepLabelErrors, AddStepLabelErrors.labelInvalidLength)
        }
    }
    
    /// Validate Pickerview tests
    
    /// Negative Hour
    func testPickerViewHour() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 0, min: 0, sec: 0))
        XCTAssertThrowsError(try viewModel.validatePickerView(hrs: -1, min: 1, sec: 1), "Hour Less than 0") { (err) in
            XCTAssertEqual(err as? AddStepPickerViewErrors, AddStepPickerViewErrors.lessThanZero)
        }
    }
    
    /// Negative minute
    func testPickerViewMinutes() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 0, min: 0, sec: 0))
        XCTAssertThrowsError(try viewModel.validatePickerView(hrs: 0, min: -1, sec: 1), "Minute Less than 0") { (err) in
            XCTAssertEqual(err as? AddStepPickerViewErrors, AddStepPickerViewErrors.lessThanZero)
        }
    }
    
    /// Negative seconds
    func testPickerViewSeconds() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 0, min: 0, sec: 0))
        XCTAssertThrowsError(try viewModel.validatePickerView(hrs: 0, min: 0, sec: -1), "Second Less than 0") { (err) in
            XCTAssertEqual(err as? AddStepPickerViewErrors, AddStepPickerViewErrors.lessThanZero)
        }
    }
    
    /// multiple negative time unit
    func testPickerViewMultipleNegatives() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 0, min: 0, sec: 0))
        XCTAssertThrowsError(try viewModel.validatePickerView(hrs: 0, min: -1, sec: -1), "Second Less than 0") { (err) in
            XCTAssertEqual(err as? AddStepPickerViewErrors, AddStepPickerViewErrors.lessThanZero)
        }
    }
    
    /// Greater than a day
    func testPickerViewOver24() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 0, min: 0, sec: 0))
        XCTAssertThrowsError(try viewModel.validatePickerView(hrs: 25, min: 0, sec: 0), "Hour over 24") { (err) in
            XCTAssertEqual(err as? AddStepPickerViewErrors, AddStepPickerViewErrors.greaterThanADay)
        }
    }
    
    /// Greater than a minute
    func testPickerViewSecondsOver60() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 0, min: 0, sec: 0))
        XCTAssertThrowsError(try viewModel.validatePickerView(hrs: 2, min: 0, sec: 61), "Seconds over 60") { (err) in
            XCTAssertEqual(err as? AddStepPickerViewErrors, AddStepPickerViewErrors.greaterThanAMinute)
        }
    }
    
    /// Greater than a hour
    func testPickerViewMinuteOver60() {
        let viewModel = AddStepViewModel(userSelectedValues: StepValues(name: nil, hour: 0, min: 0, sec: 0))
        XCTAssertThrowsError(try viewModel.validatePickerView(hrs: 2, min: 61, sec: 0), "minute over 60") { (err) in
            XCTAssertEqual(err as? AddStepPickerViewErrors, AddStepPickerViewErrors.greaterThanAnHour)
        }
    }
    
    
}
