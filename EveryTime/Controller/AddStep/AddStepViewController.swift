//
//  AddStepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 4/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

enum PickerColumn: Int {
    case hour = 0
    case min = 2
    case sec = 4
}

// refactor addstep into one base view controller
protocol AddStepProtocol {
    func grabValuesFromInput()
}

class AddStepViewController: AddStepViewControllerBase {
    var delegate: RecipeViewControllerDelegate?

    init(delegate: RecipeViewControllerWithTableView?, viewModel: AddStepViewModel) {
        super.init()
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rvc = delegate {
            
            guard let step = viewModel.step() else {
                return
            }
            
            let stepName = "\(step.name) \(rvc.stepCount())"
            viewModel.updateStepValues(name: stepName)
            labelTextField.attributedText = NSAttributedString(string: stepName, attributes: Theme.Font.Recipe.TextFieldAttribute)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let rvc = delegate {
            rvc.willReloadTableData()
        }
    }
    
    override func grabValuesFromInput() {
        let name = labelTextField.text!
        let hrs = countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
        let min = countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
        let sec = countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)
        
        do {
            try viewModel.validatePickerView(hrs: hrs, min: min, sec: sec)
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
        } catch {
            showAlertBox("Error unknown with picker view")
        }
        
        do {
            try viewModel.validateNameInput()
        } catch AddStepLabelErrors.labelNotFilled {
            showAlertBox("Please fill in the label")
        } catch AddStepLabelErrors.labelLengthTooLong {
            showAlertBox("Length too long, keep it under \(viewModel.maxCharacterLimitForNameLabel)")
        } catch AddStepLabelErrors.labelInvalidLength {
            showAlertBox("Please Invalid Length")
        } catch AddStepLabelErrors.labelLengthTooShort {
            showAlertBox("Too short")
        } catch {
            showAlertBox("Error unknown with name label")
        }
        
        guard let rvc = delegate else {
            return
        }
        viewModel.updateStepValues(name: name, hrs: hrs, min: min, sec: sec)
        viewModel.transformToEntity(priority: Int16(rvc.stepCount() - 1))
        rvc.didReturnValues(step: viewModel.grabEntity()!)
        delegate?.startTimer()
        self.dismiss(animated: true) { }
    }
}


