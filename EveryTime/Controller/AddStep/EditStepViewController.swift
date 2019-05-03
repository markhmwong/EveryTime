//
//  EditStepViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 24/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditStepViewController: AddStepViewControllerBase {
    
    weak var delegate: AddRecipeViewController?
    
    private var selectedRow: Int
    
    init(delegate: AddRecipeViewController, selectedRow: Int, viewModel: AddStepViewModel) {
        self.delegate = delegate
        self.selectedRow = selectedRow
        
        super.init()
        self.viewModel = viewModel
        self.mainView.titleLabel.attributedText = NSAttributedString(string: "Edit Step", attributes: Theme.Font.Nav.Title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let step = viewModel.grabEntity()
        
        mainView.labelTextField.attributedText = NSAttributedString(string: "\(step?.stepName ?? "Step Name")", attributes: Theme.Font.Recipe.TextFieldAttribute)
        
        let (h,m,s) = step?.getRawValues() ?? (0,0,0)
        mainView.countDownPicker.selectRow(h, inComponent: 0, animated: true)
        mainView.countDownPicker.selectRow(m, inComponent: 2, animated: true)
        mainView.countDownPicker.selectRow(s, inComponent: 4, animated: true)
    }
    
    func setPicker() {
        mainView.countDownPicker.selectRow(3, inComponent: 0, animated: true)
    }
    
    override func grabValuesFromInput() {
        super.grabValuesFromInput()
        let name = mainView.labelTextField.text!
        let hrs = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
        let min = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
        let sec = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)
        do {
            try viewModel.validatePickerView(hrs: hrs, min: min, sec: sec) //viewmodel needs to be initialised
            try viewModel.validateNameInputWithEntity(name: name)
            guard let vm = delegate?.viewModel else {
                return
            }
            let priority = vm.dataSource.count
            viewModel.createStepEntity(name: name, hours: hrs, minutes: min, seconds: sec, priority: Int16(priority))
            delegate?.didEditStep(step: viewModel.grabEntity()!, rowToUpdate: selectedRow)
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

class EditStepViewControllerInExistingRecipe: AddStepViewControllerBase {
    
    weak var delegate: RecipeViewControllerWithTableView?
    
    private var selectedRow: Int
    
    
    init(delegate: RecipeViewControllerWithTableView, selectedRow: Int, viewModel: AddStepViewModel) {
        self.delegate = delegate
        self.selectedRow = selectedRow
        
        super.init()
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareView() {
        super.prepareView()
        let step = viewModel.grabEntity()

        mainView.titleLabel.attributedText = NSAttributedString(string: "Edit Step", attributes: Theme.Font.Nav.Title)
        mainView.labelTextField.attributedText = NSAttributedString(string: "\(step?.stepName ?? "Step Name")", attributes: Theme.Font.Recipe.TextFieldAttribute)
        
        let (h,m,s) = step?.getRawValues() ?? (0,0,0)
        mainView.countDownPicker.selectRow(h, inComponent: 0, animated: true)
        mainView.countDownPicker.selectRow(m, inComponent: 2, animated: true)
        mainView.countDownPicker.selectRow(s, inComponent: 4, animated: true)
    }
    
    func setPicker() {
        mainView.countDownPicker.selectRow(3, inComponent: 0, animated: true)
    }
    
    override func grabValuesFromInput() {
        super.grabValuesFromInput()
        let name = mainView.labelTextField.text!
        let hrs = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.hour.rawValue)
        let min = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.min.rawValue)
        let sec = mainView.countDownPicker.selectedRow(inComponent: PickerColumn.sec.rawValue)
        do {
            try viewModel.validatePickerView(hrs: hrs, min: min, sec: sec) //viewmodel needs to be initialised
            try viewModel.validateNameInputWithEntity(name: name)
            guard let vm = delegate?.viewModel else {
                return
            }
            let priority = vm.dataSource.count
            viewModel.createStepEntity(name: name, hours: hrs, minutes: min, seconds: sec, priority: Int16(priority - 1))
            viewModel.grabEntity()?.updateExpiry()
            delegate?.didEditStep(step: viewModel.grabEntity()!, rowToUpdate: selectedRow)
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
