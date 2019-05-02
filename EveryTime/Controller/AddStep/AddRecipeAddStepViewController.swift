//
//  AddRecipeSettingsAddStepViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 14/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeAddStepViewController: AddStepViewControllerBase {
    weak var delegate: AddRecipeViewController?
    
    init(delegate: AddRecipeViewController?, viewModel: AddStepViewModel) {
        self.delegate = delegate
        super.init()
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.labelTextField.attributedText = NSAttributedString(string: "\(viewModel.grabEntity()?.stepName ?? "Step")", attributes: Theme.Font.Recipe.TextFieldAttribute)
    }
    
    override func grabValuesFromInput() {
        super.grabValuesFromInput()
        let name = mainView.labelTextField.text!
        let hrs = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
        let min = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
        let sec = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)
        do {
            try viewModel.validatePickerView(hrs: hrs, min: min, sec: sec)
            try viewModel.validateNameInputWithEntity(name: name)
            guard let vm = delegate?.viewModel else {
                return
            }
            let priority = vm.dataSource.count
            viewModel.createStepEntity(name: name, hours: hrs, minutes: min, seconds: sec, priority: Int16(priority))
            delegate?.didReturnValuesFromAddingStep(step: viewModel.grabEntity()!)
            self.dismiss(animated: true) { }
        } catch AddStepPickerViewErrors.allZero {
            showAlertBox("At least one unit of time must be greater than 0")
        } catch AddStepPickerViewErrors.lessThanZero {
            showAlertBox("One unit of time is less than 0")
        } catch AddStepPickerViewErrors.greaterThanADay {
            showAlertBox("Hours is greater than 24")
        } catch AddStepPickerViewErrors.greaterThanAnHour {
            showAlertBox("Minutes is greater than 60")
        } catch AddStepPickerViewErrors.greaterThanAMinute {
            showAlertBox("Seconds is greater than 60")
        } catch AddStepLabelErrors.labelNotFilled {
            showAlertBox("Please fill in the label")
        } catch AddStepLabelErrors.labelLengthTooLong {
            showAlertBox("Length too long, keep it under \(viewModel.maxCharacterLimitForNameLabel)")
        } catch AddStepLabelErrors.labelInvalidLength {
            showAlertBox("Please Invalid Length")
        } catch AddStepLabelErrors.labelLengthTooShort {
            showAlertBox("Label is too short, minimum characters is 2")
        } catch {
            showAlertBox("Error unknown with name label")
        }
    }
}
