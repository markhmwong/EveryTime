//
//  AddStepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 4/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit



// refactor addstep into one base view controller
protocol AddStepProtocol {
    func grabValuesFromInput()
}

class AddStepViewController: AddStepViewControllerBase {
    var delegate: RecipeViewControllerDelegate?

    init(delegate: RecipeViewControllerWithTableView?, viewModel: AddStepViewModel) {
        self.delegate = delegate
        super.init()
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let theme = viewModel.theme else {
            return
        }
        view.backgroundColor = theme.currentTheme.generalBackgroundColour
        mainView.backgroundColor = theme.currentTheme.generalBackgroundColour
        
        if let rvc = delegate {
            
            guard let step = viewModel.grabStepValues() else {
                return
            }
            
            let stepName = "\(step.name) \(rvc.stepCount())"
            viewModel.updateStepValues(name: stepName)
            mainView.labelTextField.attributedText = NSAttributedString(string: stepName, attributes: theme.currentTheme.font.stepName)

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let rvc = delegate {
            rvc.willReloadTableData()
        }
    }
    
    override func grabValuesFromInput() {
        super.grabValuesFromInput()
        let name = mainView.labelTextField.text!
        let hrs = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
        let min = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
        let sec = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)
        
        do {
            try viewModel.validatePickerView(hrs: hrs, min: min, sec: sec)
            try viewModel.validateNameInput()
            guard let rvc = delegate else {
                return
            }
            viewModel.updateStepValues(name: name, hrs: hrs, min: min, sec: sec)
            viewModel.transformToEntity(priority: Int16(rvc.stepCount() - 1))
            rvc.didReturnValues(step: viewModel.grabEntity()!)
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
            showAlertBox("Too short")
        } catch {
            showAlertBox("Error unknown with picker view")
        }
    }
}
